#include "my_orlogolication.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _Myorlogolication {
  Gtkorlogolication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(Myorlogolication, my_orlogolication, GTK_TYPE_orlogoLICATION)

// Implements Gorlogolication::activate.
static void my_orlogolication_activate(Gorlogolication* orlogolication) {
  Myorlogolication* self = MY_orlogoLICATION(orlogolication);
  GtkWindow* window =
      GTK_WINDOW(gtk_orlogolication_window_new(GTK_orlogoLICATION(orlogolication)));

  // Use a header bar when running in GNOME as this is the common style used
  // by orlogolications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "orlogo");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "orlogo");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements Gorlogolication::local_command_line.
static gboolean my_orlogolication_local_command_line(Gorlogolication* orlogolication, gchar*** arguments, int* exit_status) {
  Myorlogolication* self = MY_orlogoLICATION(orlogolication);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_orlogolication_register(orlogolication, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_orlogolication_activate(orlogolication);
  *exit_status = 0;

  return TRUE;
}

// Implements Gorlogolication::startup.
static void my_orlogolication_startup(Gorlogolication* orlogolication) {
  //Myorlogolication* self = MY_orlogoLICATION(object);

  // Perform any actions required at orlogolication startup.

  G_orlogoLICATION_CLASS(my_orlogolication_parent_class)->startup(orlogolication);
}

// Implements Gorlogolication::shutdown.
static void my_orlogolication_shutdown(Gorlogolication* orlogolication) {
  //Myorlogolication* self = MY_orlogoLICATION(object);

  // Perform any actions required at orlogolication shutdown.

  G_orlogoLICATION_CLASS(my_orlogolication_parent_class)->shutdown(orlogolication);
}

// Implements GObject::dispose.
static void my_orlogolication_dispose(GObject* object) {
  Myorlogolication* self = MY_orlogoLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_orlogolication_parent_class)->dispose(object);
}

static void my_orlogolication_class_init(MyorlogolicationClass* klass) {
  G_orlogoLICATION_CLASS(klass)->activate = my_orlogolication_activate;
  G_orlogoLICATION_CLASS(klass)->local_command_line = my_orlogolication_local_command_line;
  G_orlogoLICATION_CLASS(klass)->startup = my_orlogolication_startup;
  G_orlogoLICATION_CLASS(klass)->shutdown = my_orlogolication_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_orlogolication_dispose;
}

static void my_orlogolication_init(Myorlogolication* self) {}

Myorlogolication* my_orlogolication_new() {
  return MY_orlogoLICATION(g_object_new(my_orlogolication_get_type(),
                                     "orlogolication-id", orlogoLICATION_ID,
                                     "flags", G_orlogoLICATION_NON_UNIQUE,
                                     nullptr));
}
