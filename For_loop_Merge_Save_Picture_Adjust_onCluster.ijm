//For ImageJ on SLURM HPCC: Based on https://www.royfrancis.com/running-imagej-linux-cluster/

function Merge_File(dirsource, dirresult, File_ID, DAPI_Suffix, Roll_DAPI, Min_DAPI, Max_DAPI, GFP_Suffix, Roll_GFP, Min_GFP, Max_GFP, Cy3_Suffix, Roll_Cy3, Min_Cy3, Max_Cy3, Cy5_Suffix, Roll_Cy5, Min_Cy5, Max_Cy5) {
	// dirsource is the input file pathway
	// dirresult is the output file pathway
	// File_ID is the file name's beginning - can be used to pick specific files for program to run.
	// *_Suffix is the end of a files name
	// Background substraciton is performed using Process > "Subtract Background..." a rolling ball algorithm, where Roll_* is the ball radius.
	// Picture contrast controls. Min = minimum contrast, Max = maximum contrast. 0-4095 is the range for Gray scale, 0-255 is the range for colors.
	// C0 = Cy5, C1 = Cy3, C2 = Cy2, C3 = DAPI
	// Roll_* is the rolling ball setting for each cooresponding channel
	// Min_* is the minimum choosen setting for brightness/contrast in each cooresponding channel
	// Max_* is the maximum choosen setting for brightness/contrast in each cooresponding channel
	
	setBatchMode(true);
	list = getFileList(dirsource);
	print("======================================================");
	print("~~ ImageJ Tiff Image Changes ~~");
	for (i=0; i<list.length; i++) {
	    print("------------------------------------------------------");
	    print("Processing " + (i+1) + " of " + list.length + "...");
		filestart = dirsource + File_ID;
	    filename = dirsource + list[i];
		// If statments choose right image base on the suffix and selects the specific color, DAPI, GFP, Cy3, or Cy5
		//If statements are necessary because of the way images are being defined in ImageJ UNIX without GUI - getImageID()
		// Runs "Rolling ball" background substraction for each image. This substraction needs to be done with 16-bit images (using RGB from Zeiss_Z1 will cause the images to reset their pixel values when you set brightness and contrast)
		// The channels "look up" color is defined
		// The image has to be reconverted into an "RGB" format for contrast to be set
		// Sets contrast for a specific image. Could individually toggle channels, here. 0 is minimum, 4095 is the maximum for Gray scale, 0-255 for colors
		// Then saves each changed image as a PNG. I am using PNGs to save hard disk space as TIF are 4-8X larger. Also TIFs don't like color thresholding for pixel area analysis
			//Runs for DAPI image: adjusts the image for background substraction and brightness contrast
				if (startsWith(filename, filestart) && endsWith(filename, DAPI_Suffix)) {
					//open tiff image
					print("Opening " + filename);
					open(filename);
					title_DAPI = getTitle();
					print("Title " + title_DAPI);
					ImageID_DAPI = getImageID();
					
					//substack slice 2 to end
					selectImage(ImageID_DAPI);
					run("8-bit");
					run("Subtract Background...", "rolling=" + Roll_DAPI + " disable");
					run("Blue");
					run("RGB Color");
					run("Brightness/Contrast...");	
					setMinAndMax(Min_DAPI, Max_DAPI);
	
					//save tiff file
					saveAs("Tiff", dirresult + File_ID + "DAPI.tif");
					//run("OME-TIFF...", "save=" + dirresult + title_DAPI + " compression=JPEG");
					print(dirresult + title_DAPI + " saved.");
					//run("Close All");
					}		
			//Runs for GFP image: adjusts the image for background substraction and brightness contrast
				else if (startsWith(filename, filestart) && endsWith(filename, GFP_Suffix)) {
					//open tiff image
						print("Opening " + filename);
						open(filename);
						title_Cy2 = getTitle();
						print("Title " + title_Cy2);
						ImageID_Cy2 = getImageID();
	
						//substack slice 2 to end
						selectImage(ImageID_Cy2);
						run("8-bit");
						run("Subtract Background...", "rolling=" + Roll_GFP + " disable");
						run("Green");
						run("RGB Color");
						run("Brightness/Contrast...");	
						setMinAndMax(Min_GFP, Max_GFP);
		
						//save tiff file
						saveAs("Tiff", dirresult + File_ID + "Cy2.tif");
						//run("OME-TIFF...", "save=" + dirresult + title_Cy2 + " compression=JPEG");
						print(dirresult + title_Cy2 + " saved.");
						//run("Close All");
						}
			//Runs for Cy3 image: adjusts the image for background substraction and brightness contrast
				else if (startsWith(filename, filestart) && endsWith(filename, Cy3_Suffix)) {
						//open tiff image
						print("Opening " + filename);
						open(filename);
						title_Cy3 = getTitle();
						print("Title " + title_Cy3);
						ImageID_Cy3 = getImageID();
		
						//substack slice 2 to end
						selectImage(ImageID_Cy3);
						run("8-bit");
						run("Subtract Background...", "rolling=" + Roll_Cy3 + " disable");
						run("Red");
						run("RGB Color");
						run("Brightness/Contrast...");	
						setMinAndMax(Min_Cy3, Max_Cy3);
	
						//save tiff file
						saveAs("Tiff", dirresult + File_ID + "Cy3.tif");
						//run("OME-TIFF...", "save=" + dirresult + title_Cy3 + " compression=JPEG");
						print(dirresult + title_Cy3 + " saved.");
						//run("Close All");
						}
			//Runs for Cy5 image: adjusts the image for background substraction and brightness contrast
				else if (startsWith(filename, filestart) && endsWith(filename, Cy5_Suffix)) {
						//open tiff image
						print("Opening " + filename);
						open(filename);
						title_Cy5 = getTitle();
						print("Title " + title_Cy5);
						ImageID_Cy5 = getImageID();
	
						//substack slice 2 to end
						selectImage(ImageID_Cy5);
						run("8-bit");
						run("Subtract Background...", "rolling=" + Roll_Cy5 + " disable");
						run("Grays");
						run("RGB Color");
						run("Brightness/Contrast...");	
						setMinAndMax(Min_Cy5, Max_Cy5);
	
						//save tiff file
						saveAs("Tiff", dirresult + File_ID + "Cy5.tif");
						//run("OME-TIFF...", "save=" + dirresult + File_ID + ".ome.tif compression=JPEG");
						print(dirresult + title_Cy5 + " saved.");
						//run("Close All");
					} 
	  }
	  
	// Merges all images together to make a composite image where c1 = Red, c2 = Green, c3 = Blue, c4 = Gray, c5 = Cyan, c6 = Magenta, c7 = Yellow	
	run("Merge Channels...", "c1=" + File_ID + "Cy3.tif" + " c2=" + File_ID + "Cy2.tif" + " c3=" + File_ID + "DAPI.tif" + " c4=" + File_ID + "Cy5.tif" + " create keep");
	saveAs("JPEG", dirresult + File_ID + "Merged.jpeg");
	print("Merged image has been made: " + dirresult + File_ID + "Merged.jpeg");
	
	// Merges Cy5 and DAPI images together to make a composite image
	run("Merge Channels...", "c3=" + File_ID + "DAPI.tif" + " c4=" + File_ID + "Cy5.tif" + " create keep");
	saveAs("JPEG", dirresult + File_ID + "DAPI.Cy5.jpeg");
	print("A DAPi and Cy5 image has been made: " + dirresult + File_ID + "DAPI.Cy5.jpeg");
	
	// Merges Cy3 and DAPI images together to make a composite image	
	run("Merge Channels...", "c1=" + File_ID + "Cy3.tif" + " c3=" + File_ID + "DAPI.tif" + " create keep");
	saveAs("JPEG", dirresult + File_ID + "DAPI.Cy3.jpeg");
	print("A DAPi and Cy3 image has been made: " + dirresult + File_ID + "DAPI.Cy3.jpeg");
	
	// Merges Cy2 and DAPI images together to make a composite image
	run("Merge Channels...", "c2=" + File_ID + "Cy2.tif" + " c3=" + File_ID + "DAPI.tif" + " create keep");
	saveAs("JPEG", dirresult + File_ID + "DAPI.Cy2.jpeg");
	print("A DAPi and Cy2 image has been made: " + dirresult + File_ID + "DAPI.Cy2.jpeg");
	
	print("======================================================");
	}
eval("script","System.exit(0);");
//The purpose of "Merge_File" function is to open all channel images taken on a microscope, manipulate them, and merge them into single channel images, channel + DAPI images, and an all channel merge image
//Merge_File(dirsource, dirresult, File_ID, DAPI_Suffix, Roll_DAPI, Min_DAPI, Max_DAPI, GFP_Suffix, Roll_GFP, Min_GFP, Max_GFP, Cy3_Suffix, Roll_Cy3, Min_Cy3, Max_Cy3, Cy5_Suffix, Roll_Cy5, Min_Cy5, Max_Cy5)

//Merge_File("/network/rit/lab/larsenlab-rit/Nick_Moskwa/Test/","/network/rit/lab/larsenlab-rit/Nick_Moskwa/Test/Edited/","Big_","C3.tif",50,2,15,"C2.tif",50,3,15,"C1.tif",50,2,150,"C0.tif",50,2,150)
Merge_File("/network/rit/lab/larsenlab-rit/Nick_Moskwa/Test/","/network/rit/lab/larsenlab-rit/Nick_Moskwa/Test/Edited/","Exp_234_AdultGland_Methanol_20X_DAPI_DNA_Cy2_Vim_Cy3_Pdgfra_Cy5_Col1_01_2_","C3.tif",50,2,15,"C2.tif",50,3,15,"C1.tif",50,2,150,"C0.tif",50,2,150)
