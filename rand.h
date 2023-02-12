#pragma once

#ifndef __RAND__H
#define __RAND__H

#ifndef RAND_MAX
#define  RAND_MAX (1<<31)
#endif // RAND_MAX

int rand(void);

void srand(unsigned int seed);

#endif // RAND
