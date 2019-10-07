#include <windows.h>
#include <Commdlg.h>
#include <stdlib.h>
#include <string.h>
 
char* openFileDialog(const char* dialogType, const char* fileType, const char* defaultFilename) {
    OPENFILENAME ofn;
    char szFile[1024];
    HWND hwnd = NULL;
    HANDLE hf;
 
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = hwnd;
    ofn.lpstrFile = szFile;
	
	strcpy(ofn.lpstrFile, defaultFilename);
    
    ofn.nMaxFile = sizeof(szFile);
    ofn.lpstrFilter = fileType;
    ofn.nFilterIndex = 1;
    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = NULL;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_OVERWRITEPROMPT;
 
    // if (GetOpenFileName(&ofn) == TRUE) {
        
	// }
	if (strcmp(dialogType, "open") == 0) {
		GetOpenFileName(&ofn);
	} else if (strcmp(dialogType, "save") == 0) {
		GetSaveFileName(&ofn);
	}
		
	return ofn.lpstrFile;
}