#ifndef FLUTTER_MY_orlogoLICATION_H_
#define FLUTTER_MY_orlogoLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(Myorlogolication, my_orlogolication, MY, orlogoLICATION,
                     Gtkorlogolication)

/**
 * my_orlogolication_new:
 *
 * Creates a new Flutter-based orlogolication.
 *
 * Returns: a new #Myorlogolication.
 */
Myorlogolication* my_orlogolication_new();

#endif  // FLUTTER_MY_orlogoLICATION_H_
