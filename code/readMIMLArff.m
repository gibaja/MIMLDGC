%Separator used for relational attribute in arrf, it could be: '1' for "'" separator or '2' for '"' 
function [target, bags] = readMIMLArff(ArffFilename, separator)

%conversion of parameters
if(strcmp(separator, '1'))
    separator = "'";
else
    separator='"';
end;

fileID = fopen(ArffFilename,'rt');
tmp = textscan(fileID,'%s', 1000000,'Delimiter','\n'); 

data = tmp{1,1};
[nLines, ~] = size(data);
fclose(fileID);

%localiza la linea donde comienzan las bolsas
indexData=1;
for j=1:nLines    
    line = data{j,1};    
    if contains(line, '@data')       
       indexData = j+1;  
       break; %para salir del bucle       
    end
end

%recorre las bolsas
firstBag = 1;
nInstances = 1;
%bags = [];
bags = cell(1);
target = [];
for i=indexData:nLines   
   bolsa = data{i,1};  
   busca = strfind(bolsa, separator); %busca todas las ocurrencias de '. Se supone que solamente hay dos ocurrencias
   if(isempty(busca)==0) % la línea no está vacía (ej. linea en blanco al final del fichero)
        iniBolsa = busca(1)+1;
        finBolsa = busca(2)-1;
        iniLabels = finBolsa+3;
        finLabels = length(bolsa);
        strBolsa = bolsa(iniBolsa:finBolsa);
        strLabels = bolsa(iniLabels:finLabels);
        busca = strfind(strBolsa, '\n'); %busca ocurrencias de '\n'  
   
        if(isempty(busca)) %one-instance bag
            strInst=strBolsa;
            I = textscan(strInst,'%f,'); %devuelve un cell           
            I = transpose(I{1});
            B=I;
        else
            iniInst = 1;
            firstInstance = 1;
            for j=1:size(busca, 2)      
                finInst = busca(1,j)-1;
                strInst = strBolsa(iniInst:finInst);
                %fprintf('\n\t\t<%s>', strInst);
                iniInst = finInst+3; %\n son dos caracteres
                I = textscan(strInst,'%f,'); %devuelve un cell           
                I = transpose(I{1});      
                if firstInstance == 1
                    BagJ=I; %array
                    firstInstance = 0;
                else    
                    BagJ=[BagJ;I]; %concatenacion horizontal          
                end      
            end 

              %procesamos ultima instancia
            strInst = strBolsa(iniInst:length(strBolsa));
            I = textscan(strInst,'%f,'); %devuelve un cell           
            I = transpose(I{1});
            BagJ=[BagJ;I];            
            B = BagJ; %contiene un array de double con la bolsa
        end    
   
        
        L = textscan(strLabels,'%n,'); %cell que almacena las etiquetas de la bolsa
        Larray = cell2mat(L);
        Larray(Larray<=0)=-1; %sustituye 0 por -1
        %fprintf('\nstrLabels: <%s>', strLabels);
   
        if firstBag==1        
          target = Larray;
          %bags = cell(1);
          bags{1}=B;
          firstBag=0;
        else      
          target = [target, Larray]; %concatenacion vertical de un array
          bags{nInstances} = B;
         end
        nInstances = nInstances+1;
   end
end
bags = transpose(bags)
end
