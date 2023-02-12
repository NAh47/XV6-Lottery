#include "types.h"
#include "user.h"

int
main(int argc, char **argv){
	int nice_val=0;
	if(argc<=2){
		printf(1," Not enough argument\n");
	}
	else{
		nice_val=atoi(argv[1]);
		for(int i=2;i<argc;i++){
			renice(nice_val,atoi(argv[i]));
		}
	}
	exit();
}
