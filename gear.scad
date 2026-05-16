$fn=100;
n=20;//number of teeth 
m=10;//module=diameter(mm)/n 
a=20;//pressure angle
backlash=0;//in practice 0.2-0.5
s=30;//thickness

//gear construscts the 2d profile of an involute gear
module gear(n,m,a,backlash){ r=m*n/2*cos(a);
    rr=m*n/2;
    d=0.3*m;
    b=-90/n-(sin(a)*rr*180/(PI*r)-a)-d*180/(PI*r);
    module dente(){
        points=[[0,0],for(t=[0:0.05:1.2])[r*(cos(t*180/PI+b)+t*sin(t*180/PI+b)),r*(sin(t*180/PI+b)-t*cos(t*180/PI+b))],    
            for(t=[1.2:-0.05:0])[r*(cos(t*180/PI+b)+t*sin(t*180/PI+b)),-r*(sin(t*180/PI+b)-t*cos(t*180/PI+b))],
            [0,0]    
        ];
        polygon(points);
    }
    offset(r=-backlash/2-d){    
        circle(rr-1.3*m+d);
        difference(){
            for(i=[0:1:n-1])rotate(360/n*i,[0,0,1])dente();
            difference(){circle(2*rr);circle(rr+m*0.8+d);
            }
        }
    }
}

//empty_gear constructs the 2d profile of an involute gear with spokes
module empty_gear(n,m,a,backlash,num){
    l=m*0.5+m*n/2*0.1;
    t=m*n/2-m*1.5-m*n/30-l;
    difference(){
        gear(n,m,a,backlash);
        offset(r=m*n/30){
            difference(){
                circle(t);
                for(i=[0:num-1])rotate([0,0,360/num*i])translate([-m*n/30-l/2,0,0])square([2*m*n/30+l,t]);
            }
        }
    }
}

//bevel_gear constructs a conic gear with semi-opening 45 degrees
module bevel_gear(n,m,a,backlash,s){
    r=m*n/2*cos(a);
    rr=m*n/2;
    i=rr/2*(1-cos(a)*cos(a));
    j=rr*sin(a);
    k=sqrt(i*i+j*j-2*sin(a)*i*j);
    ii=i/sqrt(i*i+k*k);
    kk=k/sqrt(i*i+k*k);
    e=asin(cos(a)/k*i);
    f=2;
    b=-(90/n+sqrt(i*i+k*k)*180/(PI*r)-a)+backlash*180/(PI*r)/2;
    module dente(){
        points=[[0,0,rr],for(t=[0.1:0.05:f])if(r*(sin((t-0.05)*180/PI+b)-kk*(t-0.05)*cos((t-0.05)*180/PI+b-e))<0)[
            r*(cos(t*180/PI+b)+kk*t*sin(t*180/PI+b-e)),
            r*(sin(t*180/PI+b)-kk*t*cos(t*180/PI+b-e)),
            r*ii*t
        ],[0,0,0]];    
        faces=[for(t=[1:len(points)-3])[0,t+1,t],
        for(t=[1:len(points)-3])[len(points)-1,t,t+1],[0,1,len(points)-1],[0,len(points)-1,len(points)-2]];
        translate([0,0,-rr])scale([2,2,2])polyhedron(points=points,faces=faces,convexity=10);
    }
    module dentone(){
        intersection(){    
        union(){
            dente();
            mirror([0,1,0])dente();
            }
            cylinder(r2=0,r1=rr+sqrt(2)*m,h=rr);
        }
    }
    intersection(){
        union(){
            cylinder(r1=rr-sqrt(2)*m*1.2,r2=0,h=rr);
            for(i=[0:1:n-1])rotate(360/n*i,[0,0,1])dentone();
        }
        difference(){
            cylinder(r1=rr-sqrt(2)*m*1.2,r2=rr+rr-sqrt(2)*m,h=rr);
            translate([0,0,s])cylinder(r1=(rr-sqrt(2)*m*1.2)*(rr-s)/rr,r2=(rr-sqrt(2)*m*1.2)*(rr-s)/rr+rr,h=rr);
        }
    }
}

//EXAMPLES

            //gear    1:1

//gear(n,m,a,backlash);  
//translate([m*n,0,0])rotate(180/n,[0,0,1])gear(n,m,a,backlash);

            //gear    1:6

//translate([0,50,0]){
//gear(42,m,a,backlash);
//translate([m*49/2,0,0])gear(7,m,a,backlash);}

            //empty_gear

//empty_gear(80,1.2,15,0.3,5);

			//bevel_gear

alpha=28;
rotate([0,0,alpha])bevel_gear(n,m,a,backlash,s);
rotate([0,0,180])translate([-n*m/2,0,n*m/2])rotate([0,90,0])rotate([0,0,-alpha+180/n])bevel_gear(n,m,a,backlash,s);






    
