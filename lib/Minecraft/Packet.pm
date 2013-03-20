package Minecraft::Packet;
use Socket;
use UNIVERSAL::require;
use Carp "croak";

BEGIN {
    use Module::Find;
    my $class = __PACKAGE__;
    for my $subclass (findallmod $class) {
        $subclass  =~ s/${class}:://;
        my $method = join "_", map { lc } split "::", $subclass;
        no strict 'refs';
        *{"${class}::${method}"} = sub { $class->instance($subclass) };
    }
}

sub new { bless {},  shift }

sub instance {
    my ($self, $subclass) = @_;
    croak "subclass name not supplied\n" unless $subclass;
    my $fqcn = __PACKAGE__ . "::Packet$subclass";
    $fqcn->use or croak "can't load $fqcn: $@\n";
    return $fqcn->new;
}

sub recvPacket{
    my $self=shift;
    my $fh = shift;
    my $type = $self->recvByte($fh);
    print "type: $type \n";
    my $packet = $self->instance($type);
    $packet->recv($fh);
}
sub recvByte{
    my $self = shift;
    my $fh = shift;
    unpack("C", $self->recvStream($fh, 1));
}
sub recvShort{
    my $self = shift;
    my $fh = shift;
    unpack("n", $self->recvStream($fh, 2));
}
sub recvInt{
    my $self = shift;
    my $fh = shift;
    my ($down, $up) = unpack("vv", $self->recvStream($fh, 4));
    $up + $down;
}
sub recvString{
    my $self = shift;
    my $fh = shift;
    my $str;
    my $length = $self->recvShort($fh)*2;
    die("connection disconnect") unless(defined(recv($fh, $str, $length, MSG_WAITALL)));
    ($length, $str);
}
sub recvStream{
    my $self = shift;
    my $fh = shift;
    my $size = shift;
    my $data;
    die("connection disconnect") unless(defined(recv($fh, $data, $size, MSG_WAITALL)));
    $data;
}
sub sendPacket{
    my $self = shift;
    my $fh = shift;
    my $packet = shift;
    use YAML;
    print "send Packet:".Dump(unpack("C*", $packet))."\n";
    print $fh $packet;
}
sub sendByte{
    my $self = shift;
    my $fh = shift;
    my $byte = shift;
    $self->sendPacket($fh, pack("C", $byte));
}
sub sendShort{
    my $self = shift;
    my $fh = shift;
    my $short = shift;
    $self->sendPacket($fh, pack("n", $byte));
}
sub sendInt{
    my $self = shift;
    my $fh = shift;
    my $int = shift;
    my $up = $int >> 16 & 0xffff;
    my $down = $int & 0xffff;
    $self->sendPacket($fh, pack("vv", $up, $down));
}
sub sendBinary{
    my $self = shift;
    my $fh = shift;
    my $string = shift;
    my @chars = unpack('C*',  $string);
    my $packet = pack("n", ($#chars+1)/2).$string;
    $self->sendPacket($fh, $packet);
}
sub sendString{
    my $self = shift;
    my $fh = shift;
    my $string = shift;
    my @chars = unpack('C*',  $string);
    my $packet = pack("n", ($#chars+1)).pack("n*", @chars);
    $self->sendPacket($fh, $packet);
}

1;
