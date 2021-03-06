param aantalteams ;
param max_aantal_teams;
param comp_team ;

set runner ;
set team = 1..aantalteams;
param speed {runner};
param points {runner};
param kort {runner};
param vrouw {runner};

set omloop ;
param afstand{omloop}; 

var Z;
var match {team,runner,omloop} binary;

minimize tijd_zwakste_team: Z;

subject to 6members {i in team, k in omloop}: sum {j in runner} match[i,j,k]=1;    
# 6 lopers per team;

subject to min2woman {i in team}: sum {j in runner, k in omloop} match[i,j,k]*vrouw[j]>=2;    
# minimaal 2 vrouwen per ploeg;

subject to kortomloop {i in team,j in runner, k in omloop: kort[j]= 1 and afstand[k] >=4}: match[i,j,k] = 0;
# some runners can only handle 3km and should run less than 4Km;

subject to snel6 {i in team,k in omloop,m in omloop: k=6 and m = 2}: sum {j in runner} match[i,j,k]*speed[j]<= sum{ l in runner} match[i,l,m]*speed[l];    
# snelste loper 7km  op het laatste ( omloop 6 ipv omloop 2 )

subject to snel5 {i in team,k in omloop,m in omloop: k=5 and m = 3}: sum {j in runner} match[i,j,k]*speed[j]<= sum{ l in runner} match[i,l,m]*speed[l];    
# snelste loper 3km  op het laatste ( omloop 5 ipv omloop 3 ) 

subject to snel4 {i in team,k in omloop,m in omloop: k=4 and m = 1}: sum {j in runner} match[i,j,k]*speed[j]<= sum{ l in runner} match[i,l,m]*speed[l];    
# snelste loper 5km  op het laatste ( omloop 4 ipv omloop 3 ) 

subject to to1team {j in runner}: sum {i in team, k in omloop} match[i,j,k]<=1;    
# each runner is allocated to max 1  team 

subject to max80 {i in team}: sum {j in runner, k in omloop} match[i,j,k]*points[j]<=80;    
# points per team <= 80;

subject to minimax {i in team}: sum {j in runner, k in omloop } match[i,j,k]*speed[j]*afstand[k]<=Z;    
# introduce variable z (= maximale som van de snelheden) to handle minimax objective;

 