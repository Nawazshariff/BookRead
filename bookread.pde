import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import processing.core.*; 
import processing.xml.*; 
import neurosky.*; 
import org.json.*; 
import java.sql.*;
import java.applet.*; 			                       //applet—to_control_the_sketch
import java.awt.Dimension;                                    //encapsulates the width & height of a component in a single obj
import java.awt.Frame;                                       //creates frames
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent;                          // Component has gained or lost the input focus
import java.awt.Image; 
import java.io.*; 					  //includes classes for input and output
import java.net.*; 				         //classes supporting tcp/ip connections
import java.text.*; 					//handles numbers, dates, text
import java.util.*; 				       //classes and interface
import java.util.zip.*; 			      //reads the data from zip file
import java.util.regex.*;
import java.io.File;
import java.util.*;
import java.io.FileNotFoundException;
import java.util.Scanner;			 // against patterns specified by reg exp

public class  bookread extends PApplet {              

ThinkGearSocket neuroSocket;		//transmission and receipt of think Gear brainwave data   between a     client and a server.
BufferedReader reader_0,reader_1;
String mlines[],tough="The tough words:",words[],pagewords,print_sig="Checking status : ",waiting="connecting ...",conn_succ="connection successfull",hash,database = "dictionarystudytool";
ResourceBundle rb;
int attention = 50,blinkSt = 0,blink = 0,blink1=0,meditation=20,eeg=0,deltaa=0,thetaa=0,pages=0,line_extra,k=1,t=0,i=30,j=110,page=1,sig1,a=900,b=50,flag=0,x_word=930,y_word;
static int blink_count=0,fblink_timer=0,word_timer=0,count=0;
PFont font,p;
PImage img;
PGraphics l,r,nav;
MySQL msql;
/*------------------------------------*/

public void setup() //setup function
{
              size (1280, 720);  //Size of the entire window
              ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
              try 		//checking the connection
              {
                neuroSocket.start();
              } 
             catch (ConnectException e)
             {
              e.printStackTrace();
             }
             
            //setting file reader
              mlines=loadStrings("para.txt");
             rb=ResourceBundle.getBundle("words");

              p=createFont("couries bold",20);
                          
           //setting font
              fill(0);	
              font = createFont("Arial",20);
              textFont(font);
   
          //Basic layout
              leftside();               
              leftnav();
              calc_pages();
              meaning_area();
              tough_area();
              signal_area();


}

public void signal_area()       //bottom left part of UI  where connection values are displayed
{

  //drawing border
  fill(#ffffff);
  stroke(#000000);
  strokeWeight(2);
  rect(0,290,900,430);
  fill(#000000);
  text(print_sig,20,350);
  if(sig1!=0)		//checks for headset connection
  {
    fill(#cc0000);    //red color
    text(waiting,300,350);
  }
  else
  {
    fill(#009900);    
    text(conn_succ,300,350);
  }
    //prints values of attention, meditation and blinkstrength
	
   fill(#000000);
   text("Attention : ",20,390);
   if(attention>80) fill(#009900); else   fill(#CC0000);   
   text(""+attention,300,390);
    
   fill(#000000);  
   text("Meditation : ",20,430);   
   if(meditation>80) fill(#009900); else   fill(#CC0000);   
   text(""+meditation,300,430);
    
   fill(#000000);   
   text("BlinkStrength: ",20,470);
   if(blink>80) fill(#009900); else   fill(#CC0000);   
   text(""+blink,300,470);
   fill(#000000);   

}

public void meaning_area()   //right bottom part of UI where meaning of the words are displayed
{
    //border
    fill(#FFFFFF);
    stroke(#009999);
    strokeWeight(3);
    rect(900, 290, 380, 430);
    //connection with database
    msql = new MySQL( this, "localhost", database, "root", "" );
    pagewords=rb.getString(""+page);	//gets the paragraph of the particular page
    words=split(pagewords,' ');	       //gets the words of each sentence in the paragraph and store in an array
    try
    {
      String fetch=words[k-1];
      if ( msql.connect() )	//connection successfull
      {
         msql.query( "SELECT e.definition from entries as e where e.word='%s'",fetch);
         if( msql.next())
	 {
	    //tells the number of matched words 
            println( "this table has " + msql.getString(1) + " number of rows" );
            hash=msql.getString(1);
            fill(#003319);
            text(hash,905,290, 375, 430);
         }
              
      }
      else
      {
        // connection failed !
        println("not able to connect");
        
      }
            
    }
    catch(ArrayIndexOutOfBoundsException e)
    {
      hash="not available";
      fill(#000000);
      text(hash,900,290, 380, 430);
    }
    flag=0;
    msql.close();
                        
}


public void tough_area(){	//right top part of UI where the possible tough words are displayed
              //border
              fill(#E5FAF0);
              stroke(#009999);
              strokeWeight(3);
              rect(900, 0, 380, 290);
              //header
              strokeWeight(3);
              stroke(#009999);
              rect(900, 0, 380, 50);
              strokeWeight(1);
              //header name
              fill(#000000);
              text(tough, 920, 15, 480, 30);
              //tough words- max 6
              fill(#F8FDFA);
              stroke(#009999);
             // strokeWeight(3);
              for(int i=50;i<=250;i=i+40)
              rect(900, i, 380, 40);
                           
              
}

public void calc_pages()	//this function calcualtes the number of pages
{
    pages=mlines.length/5;
    line_extra=mlines.length%5;
}
public void leftside(){
              //for left side
              fill(#cce5ff);
              stroke(#000000);
              strokeWeight(4);
              rect(0, 50, 900, 1230);
}
public void leftnav(){
              //for navigation area
              fill(#0080ff);
              strokeWeight(4);
              stroke(#000000);
              rect(0, 0, 900, 50);
              strokeWeight(1);
              //navigational arrows
              fill(#00004c);
              stroke(#004C99);
              strokeWeight(2);
              triangle(25,25,50,10,50,40);	//for left navigation 
              fill(#00004c);
              stroke(#004C99);
              strokeWeight(2);
              triangle(860,25,835,10,835,40);	//for right navigation
}

public void para()		//left top part of the UI to display the text 
{  
  if(mlines==null) noLoop();	//if number of lines to be displayed are zero then stop
  else
  {
          if(line_extra!=0 && page==pages+1){	//for the pages with 5 lines of text
              for (int i = 5*(page-1),j=0 ; i <mlines.length; i++,j++) {
              fill(#330000);
              textFont(p);
              text(mlines[i], 4, 100+(j*20), 900, 500);
              } 
          }
          else{  				//for the pages with less than 5 lines of the text which is usually last page
              for (int i = 5*(page-1),j=0 ; i < page*5; i++,j++) {
              fill(#330000);
              textFont(p);
              text(mlines[i], 4, 100+(j*20), 900, 500);
          }
     
      }
   pagewords=rb.getString(""+page);	//gets the paragraph of the particular page
   words=split(pagewords,' ');		//gets the words of each sentence in the paragraph and store in an array
   fill(#006666);
   for (int k =0;k<words.length; k++)
      text(words[k], 930, 60+(k*40), 380, 40);
   
  }
}

public void pageno(){	//to display page number
 fill(0);
 textSize(18);
 text("Page no: ",380,34);
 fill(#ffffff);
 text(page,460,34);
 fill(0);
 textSize(20);
}

public void draw_blink_image(){

    img=loadImage("blink10.png");
    imageMode(CORNER);
    image(img, 500, 500, 380, 200);


}

/*------------------------------------*/
public void draw() {

  leftside();         
  leftnav();
  pageno();   
  tough_area();
  para();
  meaning_area();
  signal_area();
  if(! (flag==1)&& !(millis()<=(word_timer+4000)) )   //to stop the cursor movement and freeze the meaning for 4 seconds if a word is selected
  	tough_cursor();
  else
  {
     noFill();
     stroke(#FF0000);
     strokeWeight(4);
     rect(a,b,380, 40);
  }
 
  if( (blink_count!=0)&& (millis()>=(fblink_timer+1100)) ) blink_call();	//to know whether user has blinked twice or thrice
  delay(50);
  draw_blink_image();
  
  
}



public void tough_cursor()  //cursor movement function
{
   noFill();
   stroke(#000000);
   strokeWeight(4);
   rect(a,b,380, 40);
   if(blink1 >=30 && blink1<=70)
                 {
                   t=50;
                   blink1=0;
                  }
                 
                 if(t==50)
		 {
                 
                           if(b<=290)
                           {
                             b+=40;
                           }
                           if(b==290)	//end of tough area so initialize to first word
                           {
                             b=50;
                             a=900;  
                           }
                           
                           if(k<6)
                           {
                              k =k+1;
                           }
                           else	//end of tough area so go to first word
                           {    
			      k=1;
			    }
                   t=0;
                   
                 }               
                 t++;

}

public void arrowclicked(int pos,int dir)	//function to highlight particular arrow to specify direction of navigation
{
              fill(#FF3333);
              if(dir==0)	//left navigaiton
                triangle(pos,25, pos+25,10,pos+25,40);
              else		//right navigation
                triangle(pos+25,25, pos,10,pos,40);
              delay(200);
}

void keyPressed()	//navigation function
{  
    //navigation to nextpage
    if (key == 'n' && page==pages && line_extra!=0) {
      page++;
      arrowclicked(835,1);
      loop();
    }
    
    if (key == 'n' && page<pages) {	
      page++;
      arrowclicked(835,1);
      loop();
    }
    
    //to previous page
    else if (key == 'p' && page>=2) {	
      page--;
      arrowclicked(25,0);
      loop();
    }
    
  
}

public void blink_call(){	//function which tells what to do when single,double and triple blinks occur 
  switch(blink_count)
                  {
			//single blink for right navigation
                    case 1: key = 'n';
                            keyPressed();
                            break;        
		        //double blink to select a word
                    case 2:  flag=1;                         
                             word_timer=millis();
                             break;
                        //triple blink for left navigation
                    case 3: key = 'p';
                            keyPressed();
                            break;                  
                  }    
                  blink_count=0;

}


public void blinkEvent(int blinkStrength) 	//function to capture blinks
{
  
  println(blinkStrength);
  blink1=blink=blinkSt = blinkStrength;
  blinkSt-=10;	//removing additional signals
  println("after removing additional signals "+ blinkSt);
  if(blinkSt>60){	//if the strength is above 60 after removing additional signals then it is a force blink
                if(blink_count==0) fblink_timer=millis();
                blink_count++;	//increment blink counter
                fill(#ffffff);
                stroke(#003366);
                strokeWeight(4);
                rect(498, 498, 383, 203);
                for(int eye=10;eye>=1;eye--)
                {    
                  img=loadImage("blink"+eye+".png");
                  imageMode(CORNER);
                  image(img, 500, 500, 380, 200);
                  delay(10);
                }
                strokeWeight(1);
                noStroke();                
              
  }
  
}



public void meditationEvent(int meditationLevel)	//function which gives meditation value
{
  meditation=meditationLevel;
}


public void attentionEvent(int attentionLevel) {	//function which gives attention value
  //println("Attention Level: " + attentionLevel);
  attention = attentionLevel;
}


void poorSignalEvent(int sig) {	   //signal event function
  sig1=sig;
}




public void stop() {
  neuroSocket.stop();
  super.stop();
}


  static public void main(String args[]) {	//main function
    PApplet.main(new String[] { "--bgcolor=1111", "bookread" });	//call for application 
  }
}

