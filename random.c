#include "types.h"
#include "user.h"
#include "rand.h"
//#include "sys/time.h"
int
main(int argc, char ** argv)
{
//struct timeval time;
//gettimeofday( & time, NULL);
	if (argc>=1){
		srand((*argv[1]));
		for(int i=0;i<10;i++){
			printf(1, "random number is: %d\n",rand());
		}
	}
	exit();
}
