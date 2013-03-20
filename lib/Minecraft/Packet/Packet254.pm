package Minecraft::Packet::Packet254;
use base qw(Minecraft::Packet);

sub new {
  my $pkg = shift;
  bless {
    version => shift || ""
  },$pkg;
}

sub send {
    my $self = shift;
    my $fh = shift;
    $self->sendPacket( $fh, pack("C", 254) );
    $self->sendPacket( $fh, pack("C", $self->{version}) );
}

sub recv {
    my $self = shift;
    my $fh = shift;
    $self->{version} = unpack("C", $self->recvStream($fh, 1));
    $self;
}

1;
