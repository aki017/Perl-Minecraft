package Minecraft::Packet::Packet205;
use base qw(Minecraft::Packet);

sub new {
  my $pkg = shift;
  bless {
    Payload => shift || "0"
  },$pkg;
}

sub send {
    my $self = shift;
    my $fh = shift;
    $self->sendPacket( $fh, pack("C", 205) );
    $self->sendByte( $fh, $self->{Payload} );
}

sub recv {
    my $self = shift;
    my $fh = shift;
    $self->{Payload} = unpack("C", $self->recvStream($fh, 1));
    $self;
}

1;
