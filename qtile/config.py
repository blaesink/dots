from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import os
mod = "mod1"
terminal = "kitty"

os.system("setxkbmap -option ctrl:nocaps")
os.system("nitrogen --restore")
os.system("picom -b --experimental-backends")


keys = [
    # Switch between windows in current stack pane
    Key([mod], "j", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "k", lazy.layout.up(),
        desc="Move focus up in stack pane"),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "h", lazy.layout.left()),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "control"], "j", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(prompt='execute -> '),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "F2", lazy.spawn("firefox")),
    Key([mod], "m", lazy.spawn("emacs"),
        desc="Launch emacs (not daemonized at the moment"),
    Key([mod, "shift"], "l", lazy.spawn("dm-tool lock")),
    Key([mod, "shift"], "p", lazy.spawn("systemctl suspend")),
]

def make_group_names():
    return [
        ("WWW",{'layout':'max'}),
        ("DEV",{'layout':'max'}),
        #("EMACS",{'layout':'max'}),
        ("OTHER",{'layout':'monadtall'}),
        ("TERM",{'layout':'monadtall'}),
    ]

def init_groups():
    return [Group(name, **kwargs) for name, kwargs in group_names]

def init_colors():
    return {
        'active':'ED8F8A',
        'inactive':'888888',
        'warning':'EB4034',
        'foreground':'f8f8f2',

        'bar':'242842',

        'black':'000000',
        'gray':'333333',
        'white':'FFFFFF',

        'cyan':'8be9fd',
        'green':'50fa7b',
        'orange':'ffb86c',
        'pink':'ff79c6',
        'purple':'bd93f9',
        'red':'ff5555',
        'yellow':'f1fa8c',
    }

if __name__ in ["config","__main__"]:
    group_names = make_group_names()
    groups = init_groups()
    colors = init_colors()

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

layouts = [
    layout.Max(),
    layout.MonadTall(
        margin=10,
        border_focus=colors['purple'],
        border_normal=colors['gray'],),
]

widget_defaults = dict(
    font='Ubuntu',
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(linewidth = 0,padding = 3),
                widget.Clock(format='%A, %B %d - %I:%M %p',
                             foreground=colors['cyan']),
                widget.Sep(linewidth = 0, padding = 6),

                # Put things in the middle
                widget.Spacer(),
                widget.GroupBox(
                    #highlight_color = colors['active'],
                    this_current_screen_border=colors['orange'],
                    highlight_method = 'text',
                    inactive = colors['inactive'],
                    padding_x = 4,
                    use_mouse_wheel = False,
                ),

                widget.Prompt(background = colors['bar']),
                widget.Prompt(name='exit_button',background = colors['red']),

                #Push everything past here to the right side of the screen
                widget.Spacer(),
                widget.TextBox(text="|",foreground=colors['pink']),
                widget.CPU(format='CPU: {load_percent}%',
                           foreground = colors['pink'],
                           update_interval=3.0),
                widget.ThermalSensor(
                    tag_sensor='temp1',
                    foreground=colors['pink'],
                    update_interval=2.0),
                widget.TextBox(text="|",foreground=colors['pink']),
                widget.Memory(format='{MemUsed: .0f}M/{MemTotal: .0f}M',
                              foreground=colors['yellow'],
                              update_interval=2.0),
                widget.TextBox(text="|",foreground=colors['yellow']),
                widget.TextBox("BAT 0:",
                               foreground=colors['green']),
                widget.Battery(battery=0,
                               format='{percent: 2.0%}{char}',
                               low_percentage=0.1,
                               low_foreground=colors['warning'],
                               foreground=colors['green'],
                               discharge_char='v',
                               full_char='',
                               unknown_char=''),
                widget.TextBox(text="|",foreground=colors['green']),
                widget.TextBox("BAT 1:",
                               foreground= colors['cyan']),
                widget.Battery(battery=1,format='{percent: 2.0%}{char}',
                               foreground=colors['cyan'],
                               discharge_char='v',
                               full_char='',
                               unknown_char=''),
                widget.TextBox(text="|",foreground=colors['cyan']),
                widget.Systray(),
            ],
    size = 20,
    background=colors['bar']
),
),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
