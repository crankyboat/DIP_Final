#define cimg_use_jpeg
#include "../include/CImg.h"
#include "../include/dirent.h"
using namespace cimg_library;
int image_num = 0;
int channels = 3;
int main(int argc, char *argv[]) {
  char *inputDir = "../../input/";
  if(argc > 1)
  {
	  inputDir = argv[1];
  }
  else
  {
	  printf("usage: width height input_directory\n");
	  printf("use default settings\n");
  }
  CImg<unsigned char> **images_gray;

  DIR *dir;
  struct dirent *ent;
  if ((dir = opendir (inputDir)) != NULL) {
    /* print all the files and directories within directory */
	while ((ent = readdir(dir)) != NULL) {
		if (ent->d_type == DT_REG) { /* If the entry is a regular file */
			 image_num++;
		}
	}
	closedir(dir);
	images_gray = new CImg<unsigned char>*[image_num];

	dir = opendir(inputDir);
    for(int n = 0; n < image_num && ((ent = readdir (dir)) != NULL);)
	{
      if (ent->d_type == DT_REG) /* If the entry is a regular file */
	  {
	    char tmpPath[100];
		sprintf(tmpPath, "%s%s", inputDir, ent->d_name);
		/*
        CImg<unsigned char> image_gray(tmpPath);
	    int width = image_gray.width();
	    int height = image_gray.height();
		*/
		images_gray[n] = new CImg<unsigned char>(tmpPath);
		channels = images_gray[n]->spectrum();
		/*
        for(int i = 0; i < width; i++)
          for(int j = 0; j < height; j++)
          {
            (*images_gray[n])(i,j,0) = (image_gray(i,j,0) + image_gray(i,j,1) + image_gray(i,j,2))/3;
          }
		  */
        n++;
      }
	}
    closedir (dir);
  } else {
    /* could not open directory */
    printf("could not open directory \"inpput\"");
    return -1;
  }

  int width = images_gray[0]->width();
  int height = images_gray[0]->height();
  CImg<unsigned char> display(width,height,1,channels);
  CImg<long long> output(width,height,1,channels,0);
  CImgDisplay main_disp((*images_gray[0]),"lol");
  int count;
  for(count = 0; !main_disp.is_closed(); count++) {
	display = (*images_gray[count%image_num]);
    for(int i = 0; i < width; i++)
      for(int j = 0; j < height; j++)
		for(int channel = 0; channel < channels; channel++)
	        output(i,j,channel) = output(i,j,channel) + display(i,j,channel);
    main_disp.display(display);
    Sleep(10);
  }

  for(int i = 0; i < width; i++)
    for(int j = 0; j < height; j++)
		for(int channel = 0; channel < channels; channel++)
		  output(i,j,channel) = output(i,j,channel) /= count;

  FILE *fp = fopen("result.jpg", "wb");
  output.save_jpeg(fp);
  for(int i = 0; i < image_num; i++)
  {
    delete images_gray[i];
  }
  delete[] images_gray;
  return 0;
}