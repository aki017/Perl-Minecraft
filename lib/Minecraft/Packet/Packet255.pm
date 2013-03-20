package Minecraft::Packet::Packet255;
use base qw(Minecraft::Packet);

sub new {
  my $pkg = shift;
  bless {
    message => shift || ""
  },$pkg;
}

sub send {
    my $self = shift;
    my $fh = shift;

    my $data;
    $self->sendPacket( $fh, pack("C", 255));
    $data  = pack("n6", 0xa7, 0x31, 0, 0x35, 0x31, 0);
    $data .= pack("n*", unpack("U*", "1.3.6"));
    $data .= pack("n", 0);
    $data .= pack("n*", unpack("U*", $self->{message}));
    $data .= pack("n", 0);
    $data .= pack("xAxx", split(//, "0"));
    $data .= pack("(xA)*", split(//, "20"));
    $self->sendBinary( $fh, $data );
}

sub recv {
    my $self = shift;
    my $fh = shift;
    my ($size, $bin) = $self->recvString( $fh );
    $data  = pack("U*", unpack("x24n".($size/2-12-5), $bin));
    $self->{message} = $data;
    $self;
}

1;
