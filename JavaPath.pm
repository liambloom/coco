# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# I may or may not use this, but it was cool to learn. Also, some good regexes here

package JavaPath;
sub new {
    my $class = shift;
    my $self = ();
    my $path = shift // die "No path found";
    my $config = shift // die "Config required to construct new JavaPath object";
    if ($path =~ /^(?!\/)(?:(?:^|\/)[a-zA-Z_\$][\w\$]*)+\.(?:java|class|jar)$/) {
        $self{"filepath"} = $path;
        $self{"classpath"} = $path =~ s/\.(?:java|class|jar)$//gr =~ s/\//./gr;
    }
    else if ($path =~ /^(?!\.)(?:(?:^|\.)[a-zA-Z_\$][\w\$]*)+$/) {
        $self{"classpath"} = $path;
        $self{"filepath"} = $path =~ ;
    }
    bless $self, $class;
    return $self;
}