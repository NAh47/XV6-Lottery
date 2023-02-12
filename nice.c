#include "types.h"
#include "user.h"

int
main(int argc, char **argv){

	int nice_val=atoi(argv[1]);
	renice(nice_val,getpid());
	exec(argv[2],&argv[2]);
	exit();
}
