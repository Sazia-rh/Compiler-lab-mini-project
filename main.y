%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern FILE *yyin,*yyout; 
int i=0,sw=-1,fi=0,s[100];
int k,j,stop=0;
int inc=0,dec=0,g=-1,l=-1,r=-1;
int skipassgn=0;
int exitswtc=0;

struct  {
	char *s;
	float n;
	int ni;
	int f;
}store[1000];


void yyerror(char*);
int yylex(void); 

%}


%union
{
	float fvalue;
	int ivalue;
	char *string;
}

%token MAIN START END RETURN INCREMENT DECREMENT 
%token INT FLOAT CHAR DOUBLE GT LT EQ NEQ SHOW IF ELIF ELSE SWITCH CASE DEF BREAK FOR WHILE DO COND SQRT
%token<string> VARIABLE
%token<fvalue> NUMBERF
%type<ivalue> exp1  if_condition else_if if_condition1 assign asgn case default
%token<ivalue> NUMBERI


%left '+' '-' INCREMENT DECREMENT
%left '*' '/'
%left GT LT EQ NEQ
%nonassoc '<' '>'


%%
program:
	 MAIN START statements END {printf("succesfully compiled\n");}
	|
	;

statements:
	statements stmnt  {/*printf("valid statement 1\n");*/}
	|stmnt         {/*printf("valid statement 2\n");*/}
	;


stmnt:
	 declaration     {/*printf(" declaration \n");*/}
	|assign ';'       {/*printf(" assign \n");*/}
	|RETURN ';'     {printf("\nend of program\n");}
	|output ';'   {/*printf("output\n");*/}
	|conditions 
	|loops
	|'evenodd' '(' exp1 ')' ';'
				{
				int d=$3;
				  if(d%2)
				  printf("%d is odd\n",$3);
				  else
				  printf("%d is even\n",$3);

				}

    |'factorial' '(' exp1 ')' ';'
                 {
                 int k=$3,d=1,i;
                 for(i=1;i<=k;i++)
                 d=d*i;
                 printf("Factorial of %d is %d\n",$3,d);

                 }
    |'sin' '(' exp1 ')' ';'     
    			{
    			  float d=sin($3 * 3.14/180);
    			  printf("sin(%d) is %.5f\n",$3,d);
    			}     
   |'cos' '(' exp1 ')' ';'     
    			{
    			float d=cos($3* 3.14/180);
    			  printf("cos(%d) is %.5f\n",$3,d);
    			}            			   
   |'tan' '(' exp1 ')' ';'     
    			{
    			 float d=tan($3* 3.14/180);
    			  printf("tan(%d) is %.5f\n",$3,d);
    			}  
    |'log' '(' exp1 ')' ';'     
    			{
    			  float d=log($3);
    			  printf("log(%d) is %.5f\n",$3,d);
    			}   
    |SQRT '(' exp1 ')' ';'  
    			{
    			   float d=sqrt($3);
    			   printf("square root of %d is %f\n",$3,d);

    			}  
    |'power' '(' exp1 ',' exp1 ')' ';'  
    			{
    			   int d=pow($3,$5);
    			   printf("power of %d^%d is %d\n",$3,$5,d);

    			}
    |'gcd' '(' exp1 ',' exp1 ')' ';'  
    			{
    			   int i,n1,n2,gcd;
					n1=$3;
					n2=$5;
				for(i=1; i <= n1 && i <= n2; ++i)
    			  {
        
        			if(n1%i==0 && n2%i==0)
            		gcd = i;
    			   }
    			 printf("G.C.D of %d and %d is %d\n", n1, n2, gcd);
    			}  	
    |'prime' '(' exp1 ')' ';'
    			{int i, n=$3,flag=0;
    			for (i = 2; i <= n / 2; ++i) {
    					if (n % i == 0) {
      							flag = 1;
     							 break;
    								}
  						}

  					if (n == 1) {
    					printf("1 is neither prime nor composite.\n");} 
  					else {
    					if (flag == 0)
      					printf("%d is a prime number.\n", n);
   						 else
      					printf("%d is not a prime number.\n", n);}
    				}					 

	;
loops:
    FOR VARIABLE ':' NUMBERI 'to' NUMBERI
    START assign END
         {int j,k=$6-$4;
          printf("\n");
          for (j=1;j<=k;j++)
          {
           printf("the value at %d no execution in for loop is %d\n",j,$8);
          }

         }
    |WHILE '<' exp1 '>' START assign COND exp1 END
          {   printf("\n");
              if(inc && $3)
              {
              while(l<r)
              {
              printf("the value in while loop is %d\n",$6);
              l++;
              }
              inc=0;
              l=-1,r=-1;
              }
              else if(dec && $3)
              {
              while(l>r)
              {
              printf("the value in while loop is %d\n",$6);
              l--;
              }
              dec=0;
              l=-1,r=-1;

              }
              else
              {
              printf("condition not satisfied for while loop\n");
              }
          }


conditions:
     if_condition 	{
     					printf("the value of if bock is %d\n",$1);

     					}
    |switch_condition 		{
    						printf("switch block ended\n");

    						}
    ;
switch_condition:
		SWITCH '<' exp1 '>' ':' 
		{
		//printf("sw1 %d\n",$3);
		sw=$3;
		//printf("sw1 %d\n",sw);
		skipassgn=1;
		exitswtc=0;
		}
		START 
		 {
		  // printf("sw1.5 %d\n",sw);
		 }
		 cases

		 END
		 ;

  cases :
     cases case {
    		 	//printf("swg %d\n",sw);
    		    }
     |cases default  {
    		 	//printf("sws %d\n",sw);
    		    }
     |case    {
    		 	//printf("swr %d\n",sw);
    		    }
     ;

case :
    CASE '(' exp1 ')' ':'
    {
    if($3==sw)
    {
    //printf("sw2 %d  %d \n",$3,sw);
      skipassgn=0;
      exitswtc=1;
    }
    }
     assign 
     {
    // printf("sw2.5 %d  %d \n",skipassgn,exitswtc);
      
     }
     BREAK 
    {
    if(exitswtc)
    {
    //printf("sw3 \n");
     //printf("%d\n",$3);
     skipassgn=1;
      
    }

    }
    ;
 default:
   DEF ':'
   {
   if(exitswtc==0)
   skipassgn=0;
   //printf("sw4 %d \n",skipassgn);
   //skipassgn=0;
   }
    assign BREAK
   {
   //printf("sw5 \n");
     // printf("%d\n",$2);
     skipassgn=0;
     exitswtc=0;
   }
   ;  
    
if_condition:
    IF '<' exp1 '>' START if_condition1 END 
              { if($3)
                 { $$=$6;
                   //printf("if1 \n");
                 }

              }
    |IF '<' exp1 '>' START if_condition1 END else_if 
              { if($3)
                 { 
                   $$=$6;
                   //printf("if2 \n");
                 }
                 else
                 {
                 $$=$8;
                 }

              } 
   
   

    
    ; 

else_if:
     ELIF '<' exp1  '>' START if_condition1 END else_if
     {
     		if($3)
     		{
     		$$=$6;
     		//printf("if3 \n");
     		}
     		else
     		{  
     		 $$=$8;
     		 //printf("if4 \n");
     		}

     		}  
    |ELSE START if_condition1 END 
    		{
    		$$=$3;
    		//printf("if5 \n");
    		} 
    |ELIF '<' exp1 '>' START if_condition1 END
            {
            $$=$6;
           // printf("if6 \n");
            }
     ;	

if_condition1:
			exp1   {$$=$1;}
			|VARIABLE '=' exp1{$$=$3;}
			|if_condition1 VARIABLE '=' exp1
			{
			  $$=$4;
			}
			|if_condition1 exp1 {$$=$2;}
			;


output: 
      SHOW '(' VARIABLE ')'   { int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$3)==0)
									{ 
								 	 if(store[j].f==1)
								 	{
							       printf("\nThe value of variable %s is %f \n",$3,store[j].n);
								 	    }
								 	 else if(store[j].f==0)
								 	 {
								 	   printf("The value of variable %s is %d \n",$3,store[j].ni);
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("Not assigned value at %s \n",$3);}


                              }

	;

	assign:
	assign ',' asgn 
	|assign asgn
	|asgn  {$$=$1;}
	;

asgn:
	VARIABLE '=' NUMBERF     { 
								//printf(" float assgn %s= %f \n",$1,$3);
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0&&!skipassgn)
									{ 
								  	//var[$1]=$3;
								 	//printf("%d =\n",var[$1]);
								 	 $$=store[j].n=$3;
								 	 store[j].f=1;
								 	 printf("\nValue of the Variable %s=%f\t %d\n",store[j].s,store[j].n,j);
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0&&!skipassgn)
								{printf("1Not declared \n");}
	                          } 
	
	|VARIABLE '=' exp1     { 
								//printf(" exp assgn %s= %d \n",$1,$3);
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0&&!skipassgn)
									{$$=store[j].ni=$3;
								 	 //printf("\nValue of the Variable %s=%d\t %d\n",store[j].s,store[j].ni,j);
								 	 store[j].f=0;
								 	 find =1;			
								 	 break;
								 	 }
								 	 
									}
								if(find==0&&!skipassgn)
								{printf("%s Not declared \n",$1);}
	
	                          }
	|exp1                    {$$=$1;}       
                          

	


	;  

exp1:	
    NUMBERI                { $$ = $1;
								//printf(" exp1 %d \n",$1);
								}                                              
	| exp1 '+' exp1            {$$ = $1 + $3;
	 						//printf("PLUS \n");
	 						}
	|exp1 '-' exp1            {$$ = $1 - $3;
							//printf("MINUS \n");
							}
	|exp1 '*' exp1            {$$ = $1 * $3;
							//printf("MUL \n");
							}
	|exp1 '/' exp1            {$$ = $1 / $3;
							//printf("DIV \n");
							}

	|exp1 GT exp1            {$$ = $1 > $3; 
	                           l=$1;
	                           r=$3;
	                           g=1;
							//printf("GT \n");
							}
	|exp1 LT exp1            {$$ = $1<$3;
	                           l=$1;
	                           r=$3;
							//printf("DIV \n");
							}							
	|exp1 EQ exp1            {$$ = $1== $3;
							   l=$1;
	                           r=$3;
							//printf("DIV \n");
							}
	|exp1 NEQ exp1           {$$ = $1!= $3;
							  l=$1;
	                          r=$3;
							//printf("DIV \n");
							}
    |'(' exp1 ')'			{$$=$2;
                             //printf("DIV \n");
                             }                             								

	|VARIABLE  				{ 
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								  
								 	 if(store[j].f==1)
								 	{ $$=store[j].n;
								 	    //printf("%f\n",store[j].n);
								 	    }
								 	 else if(store[j].f==0)
								 	 { $$=store[j].ni;
								 	    //printf("%f\n",store[j].ni*1.0);
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("5Not assigned value at %s \n",$1);}
								}
   |INCREMENT VARIABLE 		      { int find=0,j=0;
	                            for(j=0;j<i;j++)
								{inc=1;
							  	 if(strcmp(store[j].s,$2)==0)
									{ inc=1;
								  
								 	 if(store[j].f==1)
								 	{ $$=store[j].n=store[j].n+1;
								 	}
								 	 else if(store[j].f==0)
								 	 { $$=store[j].ni=store[j].ni+1;
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("4Not assigned value at %s \n",$2);}
								}
							                               
    |DECREMENT VARIABLE 		 {	int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$2)==0)
									{ 
								     dec=1;
								 	 if(store[j].f==1)
								 	{ $$=store[j].n=store[j].n-1;}
								 	 else if(store[j].f==0)
								 	 { $$=store[j].ni=store[j].ni-1;
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("3Not assigned value at %s \n",$2);}
								}
							
  		
	;
	
	



declaration:
     type id1 ';' ;





type: 
	INT   
	|FLOAT
	|CHAR
	|DOUBLE
	;

id1:
	id1 ',' id    {/*printf(" id1\n");*/}
	|id  ;
id:
	VARIABLE                {
								store[i].s=$1;
								store[i].f=-1;
								printf("declared %s\n",store[i].s);
								i++;
	                          } 
	|VARIABLE '=' NUMBERF   {  int find=0,j=0;
								for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								 	 store[j].n=$3;
								 	 store[i].f=1;
								 	 printf("\nValue of the Variable %s=%f\t %d\n",store[j].s,store[j].n,j);
								 	 find=1;
								 	 break;
								 	 }
								}

								if(find==0)
								{
									store[i].s=$1;
									store[i].n=$3;
									store[i].f=1;
									printf("\nValue of the Variable %s=%f\t\n",store[i].s,store[i].n);
									i++;

								}
	
       						}
    |VARIABLE '=' NUMBERI	{  int find=0,j=0;
								for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								 	 store[j].ni=$3;
								 	 store[i].f=0;
								 	 printf("\nValue of the Variable %s=%d\t %d\n",store[j].s,store[j].ni,j);
								 	 find=1;
								 	 break;
								 	 }
								}

								if(find==0)
								{
									store[i].s=$1;
									store[i].ni=$3;
									store[i].f=0;
									printf("\nValue of the Variable %s=%d\t\n",store[i].s,store[i].ni);
									i++;

								}
	
       						}
	   						
    ;






%%
int yywrap()
{
    return 1;
}

int main(void)
{
   yyin=freopen("in.txt","r",stdin);
	yyout=freopen("out.txt","w",stdout);

    yyparse();

    fclose(yyin);
    fclose(yyout);
    return 0;
}
void yyerror( char *s)
{
    printf("%s\n",s);
}

