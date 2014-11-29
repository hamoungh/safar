package sed;  

//import java.io.FileOutputStream;
//import  java.io.BufferedReader;
//import java.io.FileReader; 
import  java.io.*;

public class Sed{

public  void replaceSelected(String inFile,String outFile,
			String str1,String str2) {
    try {
        // input the file content to the String "input"
        BufferedReader file = new BufferedReader(new FileReader(inFile));
		FileOutputStream File = new FileOutputStream(outFile);
        String line;


        while ((line = file.readLine()) != null){
			//input += line + '\n';
			line=line.replace(str1,str2); 
			File.write(line.getBytes());
		}


   } catch (Exception e) {
        e.printStackTrace(); 
    }
}

public static void main(String[] args) {
    new Sed().replaceSelected("","","","");    
}

}