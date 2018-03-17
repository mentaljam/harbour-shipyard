#!/usr/bin/env python3

import sys
import os
import glob
from configparser import ConfigParser
import datetime


def fatal(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
    sys.exit(1)


def to_stringlist(arg):
    if len(arg) == 0:
        return []
    return [v.strip() for v in arg.split(',')]


def to_initializer(arg):
    if len(arg) == 0:
        return 'QStringList()'
    return '{' + ', '.join(['QStringLiteral("{}")'.format(v) for v in arg]) + '}'


def need_exclude(arg):
    res = []
    for v in arg:
        if os.path.basename(v).startswith('harbour-'):
            res.append(v)
    return res


def main():

    if len(sys.argv) != 2:
        fatal('Usage: generator <output_dir>')
    if not os.path.isdir(sys.argv[1]):
        fatal('The argument must be a directory:', sys.argv[1])

    known_apps = {}
    config = ConfigParser()

    for path in glob.iglob(os.path.join(os.path.dirname(__file__), '*.ini')):
        config.read(path)
        for app in config.sections():
            if app in known_apps:
                fatal('Duplicate entry "{}": first occurrence was "{}" then "{}"'
                          .format(app, known_apps[app]['source'], path))
            app_dict = config[app]
            if not ('config' in app_dict or 'cache' in app_dict or 'local_data' in app_dict):
                fatal('{}: none of config, cache or local_data is specified for "{}"'
                          .format(path, app))
            known_apps[app] = {
                'source': path,
                'config': to_stringlist(app_dict.get('config', fallback='')),
                'cache': to_stringlist(app_dict.get('cache', fallback='')),
                'local_data': to_stringlist(app_dict.get('local_data', fallback=''))
            }
        config.clear()

    outfile = open(os.path.join(sys.argv[1], 'shipyard_known_apps.hpp'), 'w')
    outfile.write('''\
// Generated by "harbour-shipyard/known_apps/generator.py" at {}.
// Do not edit manually!

#ifndef MKNOWN_APPS_H
#define MKNOWN_APPS_H

#include <QList>
#include <QRegularExpression>

struct KnownApp
{{
    QString name;
    QStringList config;
    QStringList cache;
    QStringList local_data;
}};

inline QList<KnownApp> knownApps()
{{
    return {{
'''.format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))

    exclude = []

    for name in sorted(known_apps.keys()):
        app = known_apps[name]
        outfile.write('''\
        {{
            QStringLiteral("{}"),
            {},
            {},
            {}
        }},
'''.format(
    name,
    to_initializer(app['config']),
    to_initializer(app['cache']),
    to_initializer(app['local_data'])))
        exclude += need_exclude(app['config'])
        exclude += need_exclude(app['cache'])
        exclude += need_exclude(app['local_data'])

    regex = ''
    if len(exclude) > 0:
        regex = '(QStringLiteral("("\n               "{})"))'.format('|"\n               "'.join(sorted(exclude)))

    outfile.write('''\
    }};
}}

inline QRegularExpression excludeDirs()
{{
    static QRegularExpression regex{};
    return regex;
}}

#endif // MKNOWN_APPS_H
'''.format(regex))


if __name__ == '__main__':
    main()
