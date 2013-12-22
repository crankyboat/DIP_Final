#define cimg_use_jpeg
#include "../include/CImg.h"
#include "../include/dirent.h"
using namespace cimg_library;

const int whiteNoise_num = 30;
int uniform_distribution(int rangeLow, int rangeHigh) {
    double myRand = rand()/(1.0 + RAND_MAX); 
    int range = rangeHigh - rangeLow + 1;
    int myRand_scaled = (myRand * range) + rangeLow;
    return myRand_scaled;
}

CImg<unsigned char> **generateWhiteNoise(int n, int width, int height, int channels)
{
  srand(time(NULL));
  CImg<unsigned char> **noises = new CImg<unsigned char>*[whiteNoise_num];
  for(int no = 0; no < n; no++)
  {
	  noises[no] = new CImg<unsigned char>(width, height, 1, channels);

	  for(int i = 0; i < width; i++)
		  for(int j = 0; j < height; j++)
			  for(int channel = 0; channel < channels; channel++)
			  {
				  (*noises[no])(i,j,channel) = uniform_distribution(0,1) * 255;
			  }
  }
  return noises;
}
CImg<unsigned char> **readImg(char *inputDir, int &image_num)
{
  CImg<unsigned char> **images = NULL;
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
	images = new CImg<unsigned char>*[image_num];

	dir = opendir(inputDir);
    for(int n = 0; n < image_num && ((ent = readdir (dir)) != NULL);)
	{
      if (ent->d_type == DT_REG) /* If the entry is a regular file */
	  {
	    char tmpPath[100];
		sprintf(tmpPath, "%s%s", inputDir, ent->d_name);
		images[n] = new CImg<unsigned char>(tmpPath);
        n++;
      }
	}
    closedir (dir);
  } else {
    /* could not open directory */
    printf("could not open directory \"inpput\"");
    return NULL;
  }
  return images;
}
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
  int image_num = 0;
  CImg<unsigned char> **images = readImg(inputDir, image_num);
  int width = images[0]->width();
  int height = images[0]->height();
  int channels = images[0]->spectrum();

  CImg<unsigned char> **noises = generateWhiteNoise(whiteNoise_num, width, height, channels);

  CImg<unsigned char> display(width,height,1,channels);
  CImg<long long> output(width,height,1,channels,0);
  CImgDisplay main_disp((*images[0]),"lol");
  int count;
  for(count = 0; !main_disp.is_closed() && count < image_num*200; count++) {
	//if(count & 1 == 1)
	  //display = (*noises[count % whiteNoise_num]);
	//else
	  display = (*images[(count) % image_num]);

    for(int i = 0; i < width; i++)
      for(int j = 0; j < height; j++)
		for(int channel = 0; channel < channels; channel++)
	        output(i,j,channel) = output(i,j,channel) + display(i,j,channel);
    main_disp.display(display);
    //Sleep(20);
  }

  for(int i = 0; i < width; i++)
    for(int j = 0; j < height; j++)
		for(int channel = 0; channel < channels; channel++)
		  output(i,j,channel) = output(i,j,channel) /= count;

  FILE *fp = fopen("result.jpg", "wb");
  output.save_jpeg(fp);


  for(int i = 0; i < image_num; i++)
  {
    delete images[i];
  }
  delete[] images;

  for(int i = 0; i < whiteNoise_num; i++)
  {
    delete noises[i];
  }
  delete[] noises;
  return 0;
}