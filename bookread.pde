import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;

 import processing.core.*; 
 import processing.xml.*; 

import neurosky.*; 
import org.json.*; 
import java.sql.*;
import java.applet.*; 			                                           //applet—to_control_the_sketch
import java.awt.Dimension;                                          //encapsulates the width & height of a component in a single obj
import java.awt.Frame;                                                                                  //creates frames
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent;                                // Component has gained or lost the input focus
import java.awt.Image; 
import java.io.*; 					//includes classes for input and output
import java.net.*; 				         //classes supporting tcp/ip connections
import java.text.*; 					//handles numbers, dates, text
import java.util.*; 					//classes and interface
import java.util.zip.*; 			                             //reads the data from zip file
import java.util.regex.*;
import java.io.File;
import java.util.*;
import java.io.FileNotFoundException;
import java.util.Scanner;						                    // against patterns specified by reg exp

public class  bookread extends PApplet {              

ThinkGearSocket neuroSocket;		//transmission and receipt of think Gear brainwave data   between a     client and a server.
BufferedReader reader_0,reader_1;
String mlines[],tough="The tough words:",words[],pagewords,print_sig="Checking status : ",waiting="connecting ...",conn_succ="connection successfull";
int x_word=930,y_word;
ResourceBundle rb,rb1;
int attention = 50;
int blinkSt = 0;
int blink = 0,blink1=0;
int meditation=20;
int eeg=0;
int deltaa  =0;
int thetaa=0;
int pages=0,line_extra;
int k=1;
int t=0;
static int blink_count=0,fblink_timer=0,word_timer=0;
PFont font,p;
PImage bg;
PGraphics l,r,nav;
static int count=0;
int i=30,j=110;
int page=1;
int sig1;
int a=900,b=50;
String hash;
int flag=0;
 String database = "dictionarystudytool";
 MySQL msql;
/*------------------------------------*/
public void setup() 
{
              size (1280, 720);  //Size of the entire window
              ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
              try 
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
             rb1=ResourceBundle.getBundle("meaning");
              p=createFont("couries bold",20);
                          
             //setting font
              fill(0);
              font = createFont("Courier",20);
              textFont(font);
   
          //Basic layout
              leftside();               
              leftnav();
              calc_pages();
              meaning_area();
              tough_area();
              signal_area();


}

public void signal_area()
{
  //int count=30;
  
  fill(#e5e5ff);
  stroke(#004C99);
  strokeWeight(2);
  rect(0,290,900,800);
  
  fill(#000000);
  text(print_sig,20,350);
  if(sig1!=0)
  {
    fill(#cc0000);    //red color
    text(waiting,300,350);
  }
  else
  {
       fill(#000000);    
    text(conn_succ,300,350);
  }
    fill(#000000);
    text("Attention : ",20,390);
    fill(#000000);   
    text(""+attention,300,390);
    
   fill(#000000);  
    text("Meditation : ",20,430);   
    fill(#000000);
    text(""+meditation,300,430);
    
    fill(#000000);   
    text("BlinkStrength: ",20,470);
    fill(#000000);   
    text(""+blink,300,470);
}

public void meaning_area(){
              fill(#FFFFFF);
              //F5E5FA
              stroke(#009999);
              strokeWeight(3);
              rect(900, 290, 380, 430);
              msql = new MySQL( this, "localhost", database, "root", "" );
     pagewords=rb.getString(""+page);
    words=split(pagewords,' ');
    try{
      
    String fetch=words[k-1];
    if ( msql.connect() )
    {
        msql.query( "SELECT e.definition from entries as e where e.word='%s'",fetch);
       if( msql.next()){
        println( "this table has " + msql.getString(1) + " number of rows" );
        hash=msql.getString(1);
              fill(#000000);
              text(hash,900,290, 380, 430);
       }
              
    }
    else
    {
        // connection failed !
        println("not able to connect");
        
    }
            
    }
    catch(ArrayIndexOutOfBoundsException e){
         hash="not available";
              fill(#000000);
              text(hash,900,290, 380, 430);
    }
  flag=0;
   msql.close();


                        
}


public void tough_area(){
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

public void calc_pages(){
    pages=mlines.length/5;
    line_extra=mlines.length%5;
}
public void leftside(){
              //for left side
              fill(#b2b2ff);
              stroke(#004C99);
              strokeWeight(4);
              rect(0, 50, 900, 1230);
}
public void leftnav(){
              //for navigation area
              fill(#ffffff);
              strokeWeight(4);
              stroke(#004C99);
              rect(0, 0, 900, 50);
              strokeWeight(1);
              //navigational arrows
              fill(#00004c);
              stroke(#004C99);
              strokeWeight(2);
              triangle(25,25,50,10,50,40);
              fill(#00004c);
              stroke(#004C99);
              strokeWeight(2);
              triangle(860,25,835,10,835,40);
}


public void para(){
  
if(mlines==null) noLoop();
  else {
    if(line_extra!=0 && page==pages+1){
    for (int i = 5*(page-1),j=0 ; i <mlines.length; i++,j++) {
      fill(#435E58);
       textFont(p);
      text(mlines[i], 4, 100+(j*20), 900, 500);
      }
      
      
   }
    else{  
      for (int i = 5*(page-1),j=0 ; i < page*5; i++,j++) {
      fill(#435E58);
      textFont(p);
      text(mlines[i], 4, 100+(j*20), 900, 500);
      }
     
    }
    pagewords=rb.getString(""+page);
    words=split(pagewords,' ');
    for (int k =0;k<words.length; k++)
         text(words[k], 930, 50+(k*40), 380, 40);
   
   }
}

public void pageno(){
 fill(0);
 textSize(18);
 text("Page no: "+page,380,34);
 textSize(20);
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
  if(! (flag==1)&& !(millis()<=(word_timer+4000)) ) 
  tough_cursor();
  //show_meaning();
  if( (blink_count!=0)&& (millis()>=(fblink_timer+1100)) ) blink_call();
  delay(50);
  
}



public void tough_cursor()
{
   noFill();
   stroke(#000000);
   strokeWeight(4);
   rect(a,b,380, 40);
    if(blink1 >=50 && blink1<=70)
                 {
                   t=50;
              //   println("  Attention:" +attention);
                    blink1=0;
                  }
                 
                 if(t==50){
                 
                             if(b<=290)
                             {
                               b+=40;
                             }
                           if(b==290)
                             {
                             b=50;
                             a=900;  
                           }
                           
                            if(k<6)
                               {
                                  k =k+1;
                                }
                              else
                                {    k=1;}
                   t=0;
                   
                 }               
                 t++;

  //flag=0;


}

public void arrowclicked(int pos,int dir){
              fill(#FF3333);
              if(dir==0)
                triangle(pos,25, pos+25,10,pos+25,40);
              else
                triangle(pos+25,25, pos,10,pos,40);
              delay(200);
}
void keyPressed() {
  
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
    
    
    else if (key == 'p' && page>=2) {
      page--;
      arrowclicked(25,0);
      loop();
    }
}



public void blink_call(){
  switch(blink_count)
                  {
                    case 1: key = 'n';
                            keyPressed();
                            break;
                            
                   case 2:  flag=1;                         
                             word_timer=millis();
                             break;
                            
                    case 3: key = 'p';
                            keyPressed();
                            break;                  
                  }    
                  blink_count=0;


}


public void blinkEvent(int blinkStrength) 
{
  
  println(blinkStrength);
  blink1=blink=blinkSt = blinkStrength;
  blinkSt-=10;
  
  println("after removing additional signals "+ blinkSt);
  if(blinkSt>60){
                if(blink_count==0) fblink_timer=millis();
                blink_count++;
                
  }
  
}



public void meditationEvent(int meditationLevel)
{
  meditation=meditationLevel;
}


public void attentionEvent(int attentionLevel) {
  //println("Attention Level: " + attentionLevel);
  attention = attentionLevel;
}


void poorSignalEvent(int sig) {
  //println("SignalEvent "+sig);
  sig1=sig;
}




public void stop() {
  neuroSocket.stop();
  super.stop();
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=1111", "bookread" });
  }
}

