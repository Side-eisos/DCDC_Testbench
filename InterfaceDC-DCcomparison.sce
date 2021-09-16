clf reset;clear;clc;close;close;close;
myfigure=figure(1)
//------------------------------------------Declaration of constant---------------------------------------------------------------------------------------------------------------------------------------------------------------------
global("nom1");global("nom2");global("nom3");global("nom4");global("nom5");global("nom6");global("nom7");global("nom8");global("nom9");global("nom10");global("nom11");global("path");global("couleur")
path=get_absolute_file_path("InterfaceDC-DCcomparison.sce")
path=strsubst(path,"file\","")
myfigure.BackgroundColor= [1 1 1]
couleur=1
coeffi="1.00"
offseti="0.0009"
calibre=5

//-----------------------------------------Mise en forme du graphique-------------------------------------------------------------------------------------------------------------------------------------------------------------------
a=gca()
a.margins=[0.135,0.01,0.125,0.06]
a.background=-2
try
//    im = imread(path + '\Image\lab.png');
//    imshow(im);

end
//-----------------------------------------------------------My frame-------------------------------------------------------------------------------------------------------------------------------------------------------------------
my_frame = uicontrol("relief","groove","style","frame", "units","pixels","position",[ 2 0 200 910],"horizontalalignment","center", "background",[1 1 1],"tag","frame_control");
my_frame2 = uicontrol("relief","groove", "style","frame", "units","pixels","position",[ 2 580 200 340],"horizontalalignment","center", "background",[1 1 1],"tag","frame_control");
my_frame3 = uicontrol("relief","groove","style","frame", "units","pixels","position",[ 2 380 200 202],"horizontalalignment","center", "background",[1 1 1],"tag","frame_control");
myframetitle = uicontrol('Style','text','string','Parameters and curve',"position",[ 20 880 160 25],'fontsize',16,"horizontalalignment","center", "backgroundcolor",[1 0 0],"foregroundcolor",[1 1 1]);

//--------------------------------------------------------------Title-------------------------------------------------------------------------------------------------------------------------------------------------------------------
tool="Würth Elektronik"+ascii(039)+"s tool : DC-DC converter Efficiency comparison version 04/21"
//t1=uicontrol("style","text",'string','','position',[775 850 450 50],'fontweight','bold','fontsize',30,'fontname','times new roman','HorizontalAlignment','center',"backgroundcolor",[1 1 1],"foregroundcolor",[1 0 0])
//set(t1,"fontangle","italic")
t2=uicontrol("style","text",'string',tool,'position',[400 900 1050 50],'fontweight','bold','fontsize',30,'fontname','times new roman','HorizontalAlignment','center',"backgroundcolor",[1 1 1],"foregroundcolor",[1 0 0])
//----------------------------------------------------------Function dot replace comma--------------------------------------------------------------------------------------------------------------------------------------------------
function subs(ui)
x=strsubst(ui.string,",",".")
ui.string=string(x)
endfunction

//-------------------------------------------------------Calibration--------------------------------------------------------------------------------------------------------------------------------------------------------------------
my_frame2 = uicontrol("relief","groove","style","frame", "units","pixels","position",[ 1440 820 800 200],"horizontalalignment","center", "background",[1 1 1],"tag","frame_control");
myframetitle2 = uicontrol('Style','text','string',"Calibration : Measure in short circuit with Vin=Vout of the DC-DC converter",'position',[1445,900,460,25],'fontsize',14);

cof = uicontrol('Style','text','string',"Coefficient",'position',[1450,865,60,25]);
cof1 = uicontrol('Style','edit','String',coeffi,'position',[1510,865,60,25],'Callback_Type',2,'Callback',"subs(cof1)");
off = uicontrol('Style','text','string','Offset','position',[1450,830,60,25]);
off1 = uicontrol('Style','edit','String',offseti,'position',[1510,830,60,25],'callback',"subs(off1)");
b8=uicontrol("style","pushbutton",'string',"Reset offset for Vout=5V",'position',[1570,830,175,25],'callback',"off1.string=offseti")
b9=uicontrol("style","pushbutton",'string',"Reset Coefficent for Vout=5V",'position',[1570,865,175,25],'Callback',"cof1.string=coeffi")

//-------------------------------Interface Parameters and measurement-------------------------------------------------------------------------------------------------------------------------------------------------------------------
nam1 = uicontrol('Style','text','string',"Filename (Ex : WE-PD900k)",'position',[2,850,198,25],'fontsize',14)
nam = uicontrol('Style','edit',"String","WE-MAPI900k",'position',[2,825,100,25])
imin1 = uicontrol('Style','text','string',"Imin(A)",'position',[2,790,50,25],'fontsize',14)
imin = uicontrol('Style','edit',"String","0.01",'position',[2,765,50,25],'callback','subs(imin)')

imax1 = uicontrol('Style','text','string',"Imax(A)",'position',[2,730,50,25],'fontsize',14)
imax = uicontrol('Style','edit',"String","2",'position',[2,705,50,25],'callback','subs(imax)')

istep1 = uicontrol('Style','text','string',"Istep(A)",'position',[2,670,50,25],'fontsize',14)
istep = uicontrol('Style','edit',"String","0.1",'position',[2,645,50,25],'callback','subs(istep)')

vin1 = uicontrol('Style','text','string',"Vin(V)",'position',[2,610,50,25],'fontsize',14)
vin = uicontrol('Style','edit',"String","12",'position',[2,585,50,25],'callback','subs(vin)')

vout1 = uicontrol('Style','text','string',"Vout(V)",'position',[52,610,50,25],'fontsize',14)
vout = uicontrol('Style','edit',"String","5",'position',[52,585,50,25],'callback','subs(vout)')



b2=uicontrol("Style","pushbutton",'Callback_Type',2,'position',[55,750,145,25],'string',"Measure efficiency",'fontsize',14,'Callback',"measure(nam,imin,imax,istep,vin,couleur,cof1.string,off1.string,vout)")
waiplot=uicontrol("Style","text",'position',[55,725,145,25],'string',"Wait for the end before",'fontsize',14,'foregroundcolor',[1,0,0])
waiplot2=uicontrol("Style","text",'position',[55,700,145,25],'string',"plotting the curve",'fontsize',14,'foregroundcolor',[1,0,0])
bo=uicontrol("Style","pushbutton",'Callback_Type',2,'position',[52,800,148,20],'string',"Detect instrument",'fontsize',14,'Callback_Type',2,'Callback',"detection()")
//-----------------------------------------------Add and remove curve-------------------------------------------------------------------------------------------------------------------------------------------------------------------
name= uicontrol('Style','text','string',"Plot file",'position',[60,555,60,25],'fontsize',16,'BackgroundColor',[1 0 0],'ForegroundColor',[1 1 1])
//--------------------------------------------------------List Files Folder-------------------------------------------------------------------------------------------------------------------------------------------------------------
contenu=dir(path+"data")
conten=contenu.name
contenu1=conten'
global("cont");global("b2")
cont = uicontrol('style','popupmenu','position', [2 485 198 30],'string',contenu1,'value',1,'fontsize',14)

bouton=uicontrol("Style","pushbutton",'Callback_Type',2,'position',[2 515 198 30],'string',"Refresh",'fontsize',14,'Callback_Type',2,'Callback',"refresh(cont,contenu,b2)")
function refresh(cont,contenu,b2)
    global("cont");global("b2")
    delete(cont);delete(b2)
    contenu=dir(path+"data")
    conten=contenu.name
    contenu1=conten'
    cont = uicontrol('style','popupmenu','position', [2 485 198 30],'string',contenu1,'value',1,'fontsize',14)
    b2=uicontrol("style","pushbutton",'string',"Add curve",'position',[2,455,100,30],'Callback_Type',2,'fontsize',14,'Callback','plota((cont.string(cont.value)),couleur,cof1.string,off1.string)')
endfunction
    

//-----------------------------------------------Add and remove curve-------------------------------------------------------------------------------------------------------------------------------------------------------------------
b2=uicontrol("style","pushbutton",'string',"Add curve",'position',[2,455,100,30],'Callback_Type',2,'fontsize',14,'Callback','plota((cont.string(cont.value)),couleur,cof1.string,off1.string)')
b3=uicontrol("style","pushbutton",'string',"Remove last curve",'position',[2,425,150,30],'Callback_Type',2,'Callback',"removeplot(nom1,nom2,nom3,nom4,nom5,nom6,nom7,nom8,nom9,nom10,nom11,couleur)",'fontsize',14)
b4=uicontrol("style","pushbutton",'string',"Reset all curve",'position',[2,395,150,30],'Callback_Type',2,'Callback',"removeallplot(couleur)",'fontsize',14)
//l2 = uicontrol('style',"pushbutton",'string',"Refresh",'position',[102 525 100 30],'Callback_Type',2,'fontsize',14,'Callback','refresh(cont,b2,couleur,cof1,off1)')
/*function refresh(cont,b2,couleur,cof1,off1)
    global("cont");global("b2");delete(cont);delete(b2)
    contenu=dir(path+"data")
    conten=contenu.name
    contenu1=conten'
    cont=uicontrol('style','popupmenu','position', [2 485 198 30],'string',contenu1,'value',1,'fontsize',14)
    b2=uicontrol("style","pushbutton",'string',"Add curve",'position',[2,455,100,30],'Callback_Type',2,'fontsize',14,'Callback','plota((cont.string(cont.value)),couleur,cof1.string,off1.string)')
    
    endfunction*/
//----------------------------------------------Hide or display curves------------------------------------------------------------------------------------------------------------------------------------------------------------------
displ = uicontrol('Style','text','string',"Display curves",'position',[40,350,110,30],'fontsize',16,'BackgroundColor',[1 0 0],'ForegroundColor',[1 1 1])

h1 = uicontrol('style','checkbox','position', [2 330 28 20],"value",1, "String", "","Callback_Type",2 ,"callback","masque(h1,a.children(2).children)");
h2 = uicontrol('style','checkbox','position', [2 310 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h2,a.children(3).children)");
h3 = uicontrol('style','checkbox','position', [2 290 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h3,a.children(4).children)");
h4 = uicontrol('style','checkbox','position', [2 270 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h4,a.children(5).children)");
h5 = uicontrol('style','checkbox','position', [2 250 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h5,a.children(6).children)");
h6 = uicontrol('style','checkbox','position', [2 230 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h6,a.children(7).children)");
h7 = uicontrol('style','checkbox','position', [2 210 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h7,a.children(8).children)");
h8 = uicontrol('style','checkbox','position', [2 190 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h8,a.children(9).children)");
h9 = uicontrol('style','checkbox','position', [2 170 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h9,a.children(10).children)");
h10 = uicontrol('style','checkbox','position', [2 150 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h10,a.children(11).children)");
h11 = uicontrol('style','checkbox','position', [2 130 28 20],"value",1, "String", "" ,"Callback_Type",2,"callback","masque(h11,a.children(12).children)");

Thelp = uicontrol('Style','text','string',"(Toggle to display or hide)",'position',[62 910 138 30])

//---------------------------------------------------------Help-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

b10=uicontrol("style","radiobutton",'string',"Help",'position',[2,910,60,30],'Callback_Type',2,'Callback',"if(b10.value==1) then helpfunction else deletehelp() end",'fontsize',18,'ForegroundColor',[1 0 0])

//----------------------------------------------------------Blank before plot-----------------------------------------------------------------------------------------------------------------------------------------------------------
    nom1="";nom2="";nom3="";nom4="";nom5="";nom6="";nom7="";nom8="";nom9="";nom10="";nom11="";
//----------------------------------------------------Function plot---------------------------------------------------------------------------------------------------------------------------------------------------------------------
function plota(nom,couleur,coef,offset)
    global("nom1");global("nom2");global("nom3");global("nom4");global("nom5");global("nom6");global("nom7");global("nom8");global("nom9");global("nom10");global("nom11");global("cont");global("couleur")
    couef=strtod(coef)
    ouffset=strtod(offset)
    try
        csv_data1 = csvRead(path+"data\"+nom);
        Iin=(csv_data1(1:$,1))'
        Vin=(csv_data1(1:$,2))'
        Iout=(csv_data1(1:$,3))'
        Vout=(csv_data1(1:$,4))'
        Ioutfixed=Iout.*couef+ouffset
        Pin=Iin.*Vin
        Pout=Ioutfixed.*Vout
        Losses=Pin-Pout
        Efficiency=Pout./Pin
            select couleur
            case 1 then
                nom1=nom
                dis1 = uicontrol('Style','text','string',nom1,'position',[30 330 140 20]);
            case 2 then
                nom2=nom
                dis1 = uicontrol('Style','text','string',nom2,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom1,'position',[30 310 140 20]);
        
            case 3 then
                nom3=nom
                dis1 = uicontrol('Style','text','string',nom3,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom2,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom1,'position',[30 290 140 20]);
            case 4 then
                nom4=nom
                dis1 = uicontrol('Style','text','string',nom4,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom3,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom2,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom1,'position',[30 270 140 20]);
            case 5 then
                nom5=nom
                dis1 = uicontrol('Style','text','string',nom5,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom4,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom3,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom2,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom1,'position',[30 250 140 20]);
            case 6 then
                nom6=nom
                dis1 = uicontrol('Style','text','string',nom6,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom5,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom4,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom3,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom2,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom1,'position',[30 230 140 20]);
            case 7 then
                nom7=nom
                dis1 = uicontrol('Style','text','string',nom7,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom6,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom5,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom4,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom3,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom2,'position',[30 230 140 20]);
                dis7 = uicontrol('Style','text','string',nom1,'position',[30 210 140 20]);
            case 8 then
                nom8=nom
                couleur=couleur+5
                dis1 = uicontrol('Style','text','string',nom8,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom7,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom6,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom5,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom4,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom3,'position',[30 230 140 20]);
                dis7 = uicontrol('Style','text','string',nom2,'position',[30 210 140 20]);
                dis8 = uicontrol('Style','text','string',nom1,'position',[30 190 140 20]);
            case 14 then
                nom9=nom
                couleur=couleur+2
                dis1 = uicontrol('Style','text','string',nom9,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom8,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom7,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom6,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom5,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom4,'position',[30 230 140 20]);
                dis7 = uicontrol('Style','text','string',nom3,'position',[30 210 140 20]);
                dis8 = uicontrol('Style','text','string',nom2,'position',[30 190 140 20]);
                dis9 = uicontrol('Style','text','string',nom1,'position',[30 170 140 20]);
            case 17 then
                nom10=nom
                dis1 = uicontrol('Style','text','string',nom10,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom9,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom8,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom7,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom6,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom5,'position',[30 230 140 20]);
                dis7 = uicontrol('Style','text','string',nom4,'position',[30 210 140 20]);
                dis8 = uicontrol('Style','text','string',nom3,'position',[30 190 140 20]);
                dis9 = uicontrol('Style','text','string',nom2,'position',[30 170 140 20]);
                dis10 = uicontrol('Style','text','string',nom1,'position',[30 150 140 20]);
            case 18 then
                nom11=nom
                dis1 = uicontrol('Style','text','string',nom11,'position',[30 330 140 20]);
                dis2 = uicontrol('Style','text','string',nom10,'position',[30 310 140 20]);
                dis3 = uicontrol('Style','text','string',nom9,'position',[30 290 140 20]);
                dis4 = uicontrol('Style','text','string',nom8,'position',[30 270 140 20]);
                dis5 = uicontrol('Style','text','string',nom7,'position',[30 250 140 20]);
                dis6 = uicontrol('Style','text','string',nom6,'position',[30 230 140 20]);
                dis7 = uicontrol('Style','text','string',nom5,'position',[30 210 140 20]);
                dis8 = uicontrol('Style','text','string',nom4,'position',[30 190 140 20]);
                dis9 = uicontrol('Style','text','string',nom3,'position',[30 170 140 20]);
                dis10 = uicontrol('Style','text','string',nom2,'position',[30 150 140 20]);
                dis11 = uicontrol('Style','text','string',nom1,'position',[30 130 140 20]);
            else
                break
            end
            scf(1)
            a=gca()
            a.data_bounds=[0,0.4;2,1]
            a.margins=[0.135,0.01,0.125,0.06]
            a.background=-2
            plot2d(Ioutfixed,Efficiency,style=couleur)
            xlabel("Output current(A)","color","blue","FontSize",3)
            ylabel("Efficiency","color","blue","FontSize",3)
            title("Efficiency DC-DC Converter","color","blue","FontSize",5)
            legend(nom1,nom2,nom3,nom4,nom5,nom6,nom7,nom8,nom9,nom10,nom11)
            leg.legend_location="in_lower_right"
            scf(2)
            plot2d(Ioutfixed,Losses,style=couleur)
            xlabel("Output current(A)","color","blue","FontSize",3)
            ylabel("Losses(W)","color","blue","FontSize",3)
            title("Losses DC-DC Converter","color","blue","FontSize",5)
            leg=legend(nom1,nom2,nom3,nom4,nom5,nom6,nom7,nom8,nom9,nom10,nom11)
            leg.legend_location="in_upper_left"
            a2=gca()
            a2.data_bounds=[0,0;2,2]
            a2.margins=[0.135,0.01,0.125,0.06]
            a2.background=-2
            scf(3)
            plot2d(Ioutfixed,Vout,style=couleur)
            xlabel("Output current(A)","color","blue","FontSize",3)
            ylabel("Vout(V)","color","blue","FontSize",3)
            title("Output Voltage DC-DC Converter","color","blue","FontSize",5)
            leg=legend(nom1,nom2,nom3,nom4,nom5,nom6,nom7,nom8,nom9,nom10,nom11)
            leg.legend_location="in_upper_right"
            a3=gca()
            a3.data_bounds=[0,4;2,5]
            a3.margins=[0.135,0.01,0.125,0.06]
            a3.background=-2
            scf(1)
            couleur = couleur+1
        end
        datatipManagerMode('on')
endfunction
//---------------------------------------------------------------------Function reset---------------------------------------------------------------------------------------------------------------------------------------------------
function removeallplot(couleur)
    global("nom1");global("nom2");global("nom3");global("nom4");global("nom5");global("nom6");global("nom7");global("nom8");global("nom9");global("nom10");global("nom11");global("couleur")
        try
            delete(a)
        end
    dis1 = uicontrol('Style','text','string','','position',[30 330 140 20]);
    dis2 = uicontrol('Style','text','string','','position',[30 310 140 20]);
    dis3 = uicontrol('Style','text','string','','position',[30 290 140 20]);
    dis4 = uicontrol('Style','text','string','','position',[30 270 140 20]);
    dis5 = uicontrol('Style','text','string','','position',[30 250 140 20]);
    dis6 = uicontrol('Style','text','string','','position',[30 230 140 20]);
    dis7 = uicontrol('Style','text','string','','position',[30 210 140 20]);
    dis8 = uicontrol('Style','text','string','','position',[30 190 140 20]);
    dis9 = uicontrol('Style','text','string','','position',[30 170 140 20]);
    dis10 = uicontrol('Style','text','string','','position',[30 150 140 20]);
    dis11= uicontrol('Style','text','string','','position',[30 130 140 20]);
    nom1="";nom2="";nom3="";nom4="";nom5="";nom6="";nom7="";nom8="";nom9="";nom10="";nom11="";
    couleur=1
    scf(2)
    try
        delete(figure(2).children)
    end
    scf(3)
    try
        delete(figure(3).children)
    end
    scf(1)
    a=gca()
    a=resume(a)
endfunction
//-----------------------------------------------------------------------------------Function Remove last curve-------------------------------------------------------------------------------------------------------------------------
function removeplot(nom1,nom2,nom3,nom4,nom5,nom6,nom7,nom8,nom9,nom10,nom11,couleur)
    global("nom1");global("nom2");global("nom3");global("nom4");global("nom5");global("nom6");global("nom7");global("nom8");global("nom9");global("nom10");global("nom11");global("couleur")
    try(delete(a.children(2)))
        couleur = couleur-1
    scf(2)
        try
            delete(figure(2).children.children(2))
        end
        scf(3)
        try
            delete(figure(3).children.children(2))
        end
    scf(1)
        select couleur
        case 1 then
            dis1 = uicontrol('Style','text','string','','position',[30 330 140 20]);
        case 2 then
            dis1 = uicontrol('Style','text','string',nom1,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string','','position',[30 310 140 20]);
        case 3 then
            dis1 = uicontrol('Style','text','string',nom2,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom1,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string','','position',[30 290 140 20]);

        case 4 then
            dis1 = uicontrol('Style','text','string',nom3,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom2,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom1,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string','','position',[30 270 140 20]);
        case 5 then
            dis1 = uicontrol('Style','text','string',nom4,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom3,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom2,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom1,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string','','position',[30 250 140 20]);
        case 6 then
            dis1 = uicontrol('Style','text','string',nom5,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom4,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom3,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom2,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom1,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string','','position',[30 230 140 20]);
        case 7 then
            dis1 = uicontrol('Style','text','string',nom6,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom5,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom4,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom3,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom2,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string',nom1,'position',[30 230 140 20]);
            dis7 = uicontrol('Style','text','string','','position',[30 210 140 20]);
        case 8 then
            dis1 = uicontrol('Style','text','string',nom7,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom6,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom5,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom4,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom3,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string',nom2,'position',[30 230 140 20]);
            dis7 = uicontrol('Style','text','string',nom1,'position',[30 210 140 20]);
            dis8 = uicontrol('Style','text','string','','position',[30 190 140 20]);
        case 9 then
            dis1 = uicontrol('Style','text','string',nom8,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom7,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom6,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom5,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom4,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string',nom3,'position',[30 230 140 20]);
            dis7 = uicontrol('Style','text','string',nom2,'position',[30 210 140 20]);
            dis8 = uicontrol('Style','text','string',nom1,'position',[30 190 140 20]);
            dis9 = uicontrol('Style','text','string','','position',[30 170 140 20]);
        case 15 then
            couleur=couleur-5
            dis1 = uicontrol('Style','text','string',nom9,'position',[30 330 140 20]);
            dis2 = uicontrol('Style','text','string',nom8,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom7,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom6,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom5,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string',nom4,'position',[30 230 140 20]);
            dis7 = uicontrol('Style','text','string',nom3,'position',[30 210 140 20]);
            dis8 = uicontrol('Style','text','string',nom2,'position',[30 190 140 20]);
            dis9 = uicontrol('Style','text','string',nom1,'position',[30 170 140 20]);
            dis10 = uicontrol('Style','text','string','','position',[30 150 140 20]);
        case 18 then
            couleur=couleur-2
            dis1 = uicontrol('Style','text','string',nom10,'position',[30 330 140 20]);
         dis2 = uicontrol('Style','text','string',nom9,'position',[30 310 140 20]);
            dis3 = uicontrol('Style','text','string',nom8,'position',[30 290 140 20]);
            dis4 = uicontrol('Style','text','string',nom7,'position',[30 270 140 20]);
            dis5 = uicontrol('Style','text','string',nom6,'position',[30 250 140 20]);
            dis6 = uicontrol('Style','text','string',nom5,'position',[30 230 140 20]);
            dis7 = uicontrol('Style','text','string',nom4,'position',[30 210 140 20]);
            dis8 = uicontrol('Style','text','string',nom3,'position',[30 190 140 20]);
            dis9 = uicontrol('Style','text','string',nom2,'position',[30 170 140 20]);
            dis10 = uicontrol('Style','text','string',nom1,'position',[30 150 140 20]);
            dis11 = uicontrol('Style','text','string',"",'position',[30 130 140 20]);

        else
            break
        end
    end
endfunction
//-----------------------------------------------------------------------------------Function Display or Hide Curves--------------------------------------------------------------------------------------------------------------------
function masque(uic,courbe)
    if uic.value==0 then
        courbe.line_mode="off"
    else
        courbe.line_mode="on"
    end
endfunction
//-----------------------------------------------------------------------------------Function detect instrument-------------------------------------------------------------------------------------------------------------------------
function detection()
    txt="start powershell "+path+"file\Detection2.ps1"

    host(txt)
endfunction
//-----------------------------------------------------------------------------------Function Measure with Powershell-------------------------------------------------------------------------------------------------------------------
function measure(nom,imin,imax,istep,vin,couleur,coef,offset,vout)
global("cont");global("path");
v=strtod(vin.string)
i=strtod(imax.string)

iincal=1.3*strtod(vout.string)*strtod(imax.string)/strtod(vin.string)
if(iincal<0.5) then
    calibre=0.5
elseif(iincal<5)
    calibre=5
else
    calibre=10
end
txt=("start powershell "+path+"\file\MeasurementEfficiencyV3.ps1")
commande=(txt+" "+imax.string+" "+istep.string+" "+vin.string+" "+"1000"+" "+imin.string+" "+nom.string+" "+string(calibre))
nome=nom.string+".csv"
if(v<=32&iincal<=20&i<=30) then
    try
        host(commande)
    end
else
    Overvin = uicontrol('Style','text','string',"Vin="+vin.string+"V must be lower than 32V | Iin="+string(iincal)+"A must be lower than 10A | Iout="+imax.string+"A must be lower than 30A",'position',[300 770 1200 50],'fontsize',20,'HorizontalAlignment','center')
    sleep(4000)
    delete(Overvin)
end
endfunction
//-------------------------------------------------------Display Help-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function helpfunction()
    global("helparam");global("helparam0");global("helparam1");global("helparam3");global("helparam5");global("helpcoef");global("helpcoef1");global("helplot0");global("helplot1");global("helplot2");global("helplot3");global("helpdisp");global("helpdisp1");global("helpdet");global("helpdet1");global("helpdet2");global("helpdet3");global("helpdet4");global("helprefresh")
    helparam = uicontrol('Style','text','string',"-Type the filename without extension(WE-PD900k)",'position',[202 890 250 20])
    helparam0 = uicontrol('Style','text','string',"-Put jumpers on the PCB and name your file",'position',[202 870 250 20])
    helpdet1= uicontrol('Style','text','string',"-Press to detect 3 instruments and observe :",'position',[202 845 280 20])
    helpdet2= uicontrol('Style','text','string',"ITECH Ltd., IT6724C, 802136083737810069,  1.11-1.04",'position',[202 825 280 20])
    helpdet3= uicontrol('Style','text','string',"GWInstek,GDM8341,GEU830188,1.04",'position',[202 805 280 20])
    helpdet4= uicontrol('Style','text','string',"KORAD-KEL103 V1.00 SN:07937623",'position',[202 785 280 20])
    helpdet= uicontrol('Style','text','string',"If not, unplug and replug USB connections",'position',[202 765 280 20])
    helparam1 = uicontrol('Style','text','string',"-Choose all your parameters and",'position',[202 740 210 20])
    helparam3 = uicontrol('Style','text','string',"press the button called measure efficiency",'position',[202 720 210 20])
    helparam5 = uicontrol('Style','text','string',"-You can use Scilab during a measurement ",'position',[62 660 210 20])
    helpcoef = uicontrol('Style','text','string',"-HELP : The calibration is used to correct default measure observed with a little current",'position',[1450 800 500 20])
    helpcoef1 = uicontrol('Style','text','string'," you can add an offset or change the coefficient",'position',[1450 780 500 20])
    helprefresh = uicontrol('Style','text','string',"-Refresh the Popumenu after measuring",'position',[202 520 230 20])
    helplot0 = uicontrol('Style','text','string',"-Plot: select your file and press Add Curve",'position',[202 490 210 20])
    helplot1 = uicontrol('Style','text','string',"-Add datatips on the curve with a left click",'position',[102 460 210 20])
    helplot2 = uicontrol('Style','text','string',"-Remove the last curve you add",'position',[152 430 180 20])
    helplot3 = uicontrol('Style','text','string',"-Reset the graphic",'position',[152 400 180 20])
    helpdisp = uicontrol('Style','text','string',"-Display: You can hide some curves to compare",'position',[172 310 230 25])
    helpdisp1 = uicontrol('Style','text','string',"different inductor, switching frequency,etc",'position',[172 290 230 25])
endfunction
//-----------------------------------------------------------------------------------Delete Help----------------------------------------------------------------------------------------------------------------------------------------
function deletehelp()
    global("helparam");global("helparam0");global("helparam1");global("helparam3");global("helparam5");global("helpcoef");global("helpcoef1");global("helplot0");global("helplot1");global("helplot2");global("helplot3");global("helpdisp");global("helpdisp1");global("helpdet");global("helpdet1");global("helpdet2");global("helpdet3");global("helpdet4");global("helprefresh")
    delete(helparam);delete(helparam0);delete(helparam1);delete(helparam3);delete(helparam5);delete(helpcoef);delete(helpcoef1);delete(helplot0);delete(helplot1);delete(helplot2);delete(helplot3);delete(helpdisp);delete(helpdisp1);delete(helpdet);delete(helpdet1);delete(helpdet2);delete(helpdet3);delete(helpdet4);delete(helprefresh)
endfunction
