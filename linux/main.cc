#include "my_orlogolication.h"

int main(int argc, char** argv) {
  g_autoptr(Myorlogolication) orlogo = my_orlogolication_new();
  return g_orlogolication_run(G_orlogoLICATION(orlogo), argc, argv);
}
