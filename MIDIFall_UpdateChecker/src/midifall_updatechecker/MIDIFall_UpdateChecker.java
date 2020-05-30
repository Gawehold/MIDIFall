package midifall_updatechecker;

import java.net.*;
import java.io.*;

public class MIDIFall_UpdateChecker {
    static int numOfLine = 3;
    
    private static void printError() {
        System.out.println("Invalid version file. Please go to the official website to check for updates.");
    }
    
    public static void main(String[] args) throws Exception {
        URL webpage = new URL("https://www.weebly.com/editor/uploads/5/5/3/3/5533372/custom_themes/344578208699819211/files/MIDIFall/latest_version.html");
        
        URLConnection connection = webpage.openConnection();
        
        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        String inputLine;
        int i = 0;
        
        while ((inputLine = in.readLine()) != null) {
            switch (i) {
                case 0:
                    if (!inputLine.equals("MIDIFall UPDATE CHECKER")) {
                        printError();
                        in.close();
                        return;
                    }
                    break;
                case 1:
                    String str = "MIDIFall VERSION";
                    if (!inputLine.substring(0, str.length()).equals(str)) {
                        printError();
                        in.close();
                        return;
                    } else {
                        System.out.println(inputLine);
                    }
                    break;
                case 2:
                    if (!inputLine.equals("MIDIFall END")) {
                        printError();
                        in.close();
                        return;
                    }
                    break;
                default:
                    printError();
                    in.close();
                    return;
            }
            i++;
        }
        in.close();
        
        
    }
}