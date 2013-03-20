package Minecraft::Packet::Packet252;
use base qw(Minecraft::Packet);
use MIME::Base64;

sub new {
  my $pkg = shift;
  bless {
      SharedSecret => shift || "" , 
      VerifyToken => shift || ""
  },$pkg;
}

sub recv {
    my $self = shift;
    my $fh = shift;

    $self->{SharedSecret} = $self->recvBytes( $fh);
    $self->{VerifyToken} = $self->recvBytes( $fh);
    $self;
}
sub send {
    my $self = shift;
    my $fh = shift;

    $self->sendPacket( $fh, pack("C", 252));
    $self->sendBytes( $fh, $self->{SharedSecret});
    $self->sendBytes( $fh, $self->{VerifyToken});
}

1;
