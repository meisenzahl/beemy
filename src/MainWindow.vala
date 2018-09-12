/*
* Copyright (c) 2018 Lains
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

namespace Beemy {
    public class MainWindow : Gtk.ApplicationWindow {
        //calc page widgets
        public Gtk.Label label_beemy;
        public Gtk.Label label_beemy_info;
        public Gtk.ComboBoxText base_weight_cb;
        public Gtk.ComboBoxText base_height_cb;
        public string weight_cb_text;
        public string height_cb_text;

        //results page widgets
        public Gtk.Label label_result;
        public Gtk.Label label_result_info;
        public Gtk.Label label_result_grade;
        public string grade_type;
        public string bmi_result;
        public Gtk.Button return_button;

        public Gtk.Stack stack;

        public double res = 0.0;
        public double weight_entry_text = 0.0;
        public double height_entry_text = 0.0;

        public MainWindow (Gtk.Application application) {
            GLib.Object (application: application,
                         icon_name: "com.github.lainsce.beemy",
                         resizable: false,
                         title: "",
                         height_request: 450,
                         width_request: 450,
                         border_width: 6
            );
        }

        construct {
            var settings = AppSettings.get_default ();
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/lainsce/beemy/stylesheet.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            var titlebar = new Gtk.HeaderBar ();
            titlebar.has_subtitle = false;
            titlebar.show_close_button = true;

            var help_button = new Gtk.Button ();
            help_button.set_image (new Gtk.Image.from_icon_name ("help-contents-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            help_button.set_always_show_image (true);
            help_button.vexpand = false;
            help_button.tooltip_text = _("Learn about Body Mass Index");

            help_button.clicked.connect (() => {
                Granite.Services.System.open_uri("https://en.wikipedia.org/wiki/Body_mass_index");
            });

            titlebar.pack_end (help_button);


            var titlebar_style_context = titlebar.get_style_context ();
            titlebar_style_context.add_class (Gtk.STYLE_CLASS_FLAT);
            titlebar_style_context.add_class ("default-decoration");
            titlebar_style_context.add_class ("beemy-toolbar");

            //
            //
            // CALC PAGE
            //
            //
            label_beemy = new Gtk.Label ("Beemy");
            label_beemy.set_halign (Gtk.Align.CENTER);
            label_beemy.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
            label_beemy.hexpand = true;
            label_beemy.margin_bottom = 6;

            label_beemy_info = new Gtk.Label ("Calculate your Body Mass Index:");
            label_beemy_info.set_halign (Gtk.Align.CENTER);
            label_beemy_info.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            label_beemy_info.hexpand = true;
            label_beemy_info.margin_bottom = 6;

            var entry_weight = new Gtk.Entry ();
            entry_weight.vexpand = false;
            entry_weight.hexpand = true;
            entry_weight.has_focus = false;
            entry_weight.margin_top = 5;
            entry_weight.margin_bottom = 5;
            entry_weight.set_text ("Enter weight…");

            entry_weight.activate.connect (() => {
                weight_entry_text = double.parse(entry_weight.get_text ());
            });

            var entry_height = new Gtk.Entry ();
            entry_height.vexpand = false;
            entry_height.hexpand = true;
            entry_height.has_focus = false;
            entry_height.margin_top = 5;
            entry_height.margin_bottom = 5;
            entry_height.set_text ("Enter height…");

            entry_height.activate.connect (() => {
                height_entry_text = double.parse(entry_height.get_text ());
            });

            base_weight_cb = new Gtk.ComboBoxText();
            base_weight_cb.append_text(_("kg"));
            base_weight_cb.append_text(_("lbs"));
            base_weight_cb.margin = 6;

            if (settings.weight_type == 0) {
                base_weight_cb.set_active(0);
                weight_cb_text = "kg";
            } else if (settings.weight_type == 1) {
                base_weight_cb.set_active(1);
                weight_cb_text = "lbs";
            } else {
                base_weight_cb.set_active(0);
                weight_cb_text = "kg";
            }

            base_height_cb = new Gtk.ComboBoxText();
            base_height_cb.append_text("m");
            base_height_cb.append_text("ft");
            base_height_cb.margin = 6;

            if (settings.height_type == 0) {
                base_height_cb.set_active(0);
                height_cb_text = "m";
            } else if (settings.height_type == 1) {
                base_height_cb.set_active(1);
                height_cb_text = "ft";
            } else {
                base_height_cb.set_active(0);
                height_cb_text = "m";
            }

            base_weight_cb.changed.connect (() => {

            });

            base_height_cb.changed.connect (() => {

            });

            var weight_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
			weight_help.halign = Gtk.Align.START;
			weight_help.hexpand = true;
            weight_help.tooltip_text = _("You can choose your preferred weight unit.");

            var height_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
			height_help.halign = Gtk.Align.START;
			height_help.hexpand = true;
            height_help.tooltip_text = _("You can choose your preferred height unit.");

            var color_button_action = new Gtk.Button ();
            color_button_action.has_focus = false;
            color_button_action.halign = Gtk.Align.CENTER;
            color_button_action.margin_top = 6;
            color_button_action.height_request = 48;
            color_button_action.width_request = 48;
            color_button_action.set_image (new Gtk.Image.from_icon_name ("go-next-symbolic", Gtk.IconSize.LARGE_TOOLBAR));
            color_button_action.set_always_show_image (true);
            color_button_action.tooltip_text = _("Calculate!");
            var color_button_action_context = color_button_action.get_style_context ();
            color_button_action_context.add_class ("color-button");
            color_button_action_context.add_class ("color-button-action");

            var home_grid = new Gtk.Grid ();
            home_grid.margin_top = 0;
            home_grid.column_spacing = 6;
            home_grid.row_spacing = 6;
            home_grid.attach (label_beemy, 0, 0, 3, 1);
            home_grid.attach (label_beemy_info, 0, 1, 3, 1);
            home_grid.attach (entry_weight, 0, 2, 1, 1);
            home_grid.attach (entry_height, 0, 3, 1, 1);
            home_grid.attach (base_weight_cb, 1, 2, 1, 1);
            home_grid.attach (base_height_cb, 1, 3, 1, 1);
            home_grid.attach (weight_help, 2, 2, 1, 1);
            home_grid.attach (height_help, 2, 3, 1, 1);
            home_grid.attach (color_button_action, 0, 4, 3, 1);

            //
            //
            // RESULT PAGE
            //
            //

            label_result = new Gtk.Label ("Your Results:");
            label_result.set_halign (Gtk.Align.START);
            label_result.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
            label_result.hexpand = true;
            label_result.margin_bottom = 6;

            body_mass_index_res ();
            body_mass_index_grade ();

            label_result_info = new Gtk.Label ("");
            label_result_info.set_markup ("You are %s".printf(grade_type));
            label_result_info.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            label_result_info.set_halign (Gtk.Align.START);
            label_result_info.hexpand = true;
            label_result_info.margin_bottom = 6;

            label_result_grade = new Gtk.Label ("");
            label_result_grade.set_markup ("Your Body Mass Index is:\n %.2f".printf(res));
            label_result_grade.set_halign (Gtk.Align.START);
            label_result_grade.hexpand = true;
            label_result_grade.margin_bottom = 6;

            var results_grid = new Gtk.Grid ();
            results_grid.margin_top = 0;
            results_grid.column_spacing = 6;
            results_grid.row_spacing = 6;
            results_grid.attach (label_result, 0, 0, 3, 1);
            results_grid.attach (label_result_info, 0, 1, 3, 1);
            results_grid.attach (label_result_grade, 0, 2, 3, 1);

            stack = new Gtk.Stack ();
            stack.margin = 6;
            stack.margin_top = 0;
            stack.homogeneous = true;
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.add (home_grid);
            stack.add (results_grid);
            stack.set_visible_child (home_grid);

            return_button = new Gtk.Button.with_label ("Calculate");
            return_button.vexpand = false;
            return_button.margin_top = 5;
            return_button.margin_bottom = 5;
            return_button.get_style_context ().add_class ("back-button");
            show_return (false);

            return_button.clicked.connect (() => {
                stack.set_visible_child (home_grid);
                show_return (false);
            });

            color_button_action.clicked.connect (() => {
                stack.set_visible_child (results_grid);
                titlebar.pack_start (return_button);
                show_return (true);
            });

            this.add (stack);
            stack.show_all ();
            this.set_titlebar (titlebar);
            this.get_style_context ().add_class ("rounded");

            int x = settings.window_x;
            int y = settings.window_y;
            int weight_type = base_weight_cb.get_active();
            weight_type = settings.weight_type;
            int height_type = base_height_cb.get_active();
            height_type = settings.height_type;

            if (x != -1 && y != -1) {
                move (x, y);
            }

            button_press_event.connect ((e) => {
                if (e.button == Gdk.BUTTON_PRIMARY) {
                    begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
                    return true;
                }
                return false;
            });
        }

        public override bool delete_event (Gdk.EventAny event) {
            int x, y;
            get_position (out x, out y);

            var settings = AppSettings.get_default ();
            settings.window_x = x;
            settings.window_y = y;
            settings.weight_type = base_weight_cb.get_active();
            settings.height_type = base_height_cb.get_active();

            return false;
        }

        public void show_return (bool v) {
            return_button.set_visible (v);
        }

        public double body_mass_index_res () {
            res = (height_entry_text * height_entry_text) / weight_entry_text;
            return res;
        }

        public string body_mass_index_grade () {
            if (res < 24.0) {
                grade_type = "Underweight";
            } else if (res == 24.0) {
                grade_type = "Healthy";
            } else if (24.0 < res < 30.0) {
                grade_type = "Obese";
            } else if (res > 30.0) {
                grade_type = "Overweight";
            }

            return grade_type;
        }
    }
}