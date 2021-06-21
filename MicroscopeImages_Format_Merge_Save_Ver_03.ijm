function Merge_File(dir1, dir2, Suffix, File_ID,  Min_C1, Max_C1, Min_C2, Max_C2, Min_C3, Max_C3, Min_C4, Max_C4) {
// dir1 is the input file pathway
// dir2 is the output file pathway
// File_ID is the file name's beginning - can be used to pick specific files for program to run.
// Suffix is the end of a files name
// Picture contrast controls. Min = minimum contrast, Max = maximum contrast. 0-4095 is the range for Gray scale, 0-255 is the range for colors.
// C1 = Cy5, C2 = Cy3, C3 = Cy2, C4 = DAPI

	list = getFileList(dir1);
	setBatchMode(true);
	// list is a list of all filenames in dir1
	
	for (i=0; i<list.length; i++) {
// loops from 0 to 'i', where 'i' is file lists' length
		showProgress(i+1, list.length);
		filestart = dir1 + File_ID;
		filename = dir1 + list[i];
// "filename" is pathway and the file name together; allows imageJ to define each image to open
// "filestart" is used to select file names based on the name's beginning string.
		if (startsWith(filename, filestart) && endsWith(filename, Suffix)) {
			print(filename);
			open(filename);
			selectWindow(list[i]);
			//run("16-bit");
			// Sets the pixel size for opened image
			//run(color);
			// Sets the LUT of the image to "color"
			//run("Brightness/Contrast...");
			//setMinAndMax(Min, Max);
			// Sets contrast for a specific image. Applies to all images opened in loop. 0 is minimum, 4095 is the maximum for Gray scale, 0-255 for colors
			//run("Close");
			// Closes Brightness/Contrast window
		}
	}

	selectWindow(File_ID + "DAPI" + Suffix);
	run("Brightness/Contrast...");
	setMinAndMax(Min_C4, Max_C4);
	saveAs("PNG", dir2 + File_ID + "DAPI.png");

	selectWindow(File_ID + "GFP" + Suffix);
	run("Brightness/Contrast...");
	setMinAndMax(Min_C3, Max_C3);
	saveAs("PNG", dir2 + File_ID + "Cy2.png");

	selectWindow(File_ID + "Cy3" + Suffix);
	run("Brightness/Contrast...");
	setMinAndMax(Min_C2, Max_C2);
	saveAs("PNG", dir2 + File_ID + "Cy3.png");	

	selectWindow(File_ID + "Cy5" + Suffix);
	//run("16-bit");
	//run("RGB Color");
	run("Brightness/Contrast...");	
	setMinAndMax(Min_C1, Max_C1);	
	saveAs("PNG", dir2 + File_ID + "Cy5.png");
	// Sets contrast for a specific image. Could individually toggle channels, here. 0 is minimum, 4095 is the maximum for Gray scale, 0-255 for colors
	// Then saves each changed image as a PNG

	run("Merge Channels...", "c1=" + File_ID + "Cy3.png" + " c2=" + File_ID + "Cy2.png" + " c3=" + File_ID + "DAPI.png" + " c4=" + File_ID + "Cy5.png" + " create keep");
	// Merges all images together to make a composite image where c1 = Red, c2 = Green, c3 = Blue, c4 = Gray, c5 = Cyan, c6 = Magenta, c7 = Yellow
	saveAs("PNG", dir2 + File_ID + "Merged.png");

	run("Merge Channels...", "c3=" + File_ID + "DAPI.png" + " c4=" + File_ID + "Cy5.png" + " create keep");
	run("RGB Color", "slices keep");
	// Creates a composite image that you can now move through the stacks using the following "for" loop
	// Merges DAPI and Cy5 images together to make a composite image where c1 = Red, c2 = Green, c3 = Blue, c4 = Gray, c5 = Cyan, c6 = Magenta, c7 = Yellow
	saveAs("PNG", dir2 + File_ID + "DAPI.Cy5.png");
	
	run("Merge Channels...", "c1=" + File_ID + "Cy3.png" + " c3=" + File_ID + "DAPI.png" + " create keep");
	run("RGB Color", "slices keep");
	// Creates a composite image that you can now move through the stacks using the following "for" loop
	// Merges DAPI and Cy3 images together to make a composite image where c1 = Red, c2 = Green, c3 = Blue, c4 = Gray, c5 = Cyan, c6 = Magenta, c7 = Yellow
	saveAs("PNG", dir2 + File_ID + "DAPI.Cy3.png");

	run("Merge Channels...", "c2=" + File_ID + "Cy2.png" + " c3=" + File_ID + "DAPI.png" + " create keep");
	run("RGB Color", "slices keep");
	// Creates a composite image that you can now move through the stacks using the following "for" loop
	// Merges DAPI and Cy2 images together to make a composite image where c1 = Red, c2 = Green, c3 = Blue, c4 = Gray, c5 = Cyan, c6 = Magenta, c7 = Yellow
	saveAs("PNG", dir2 + File_ID + "DAPI.Cy2.png");
	close();
	// closes Image window

}

// The purpose of "Merge_File" function is to open all channel images taken on a microscope, manipulate them, and merge them into a single overlay image
//Merge_File(dir1, dir2, list, Suffix, File_ID,  Min_C1, Max_C1, Min_C2, Max_C2, Min_C3, Max_C3, Min_C4, Max_C4)
//Merge_File("Z:\\Nick_Moskwa\\Research\\Data\\Exp_096_E16_Epi_Mgel_PEG_20180723\\ICC\\Zeiss\\", "Z:\\Nick_Moskwa\\Research\\Data\\Exp_096_E16_Epi_Mgel_PEG_20180723\\ICC\\Zeiss\\Edited\\", ".TIF", "Exp_096_E16.0.25.Epi.0.0.Mes_T001_5X_DAPI_DNA_Cy2_EpCam_Cy3_AQP5_Cy5_Vim_01_A_", 5, 50, 10, 180, 5, 60, 0, 220)
