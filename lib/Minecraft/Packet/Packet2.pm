package Minecraft::Packet::Packet2;
use Socket;
use base qw(Minecraft::Packet);

sub new {
  my $pkg = shift;
  bless {
    protocolVersion => shift || 51, 
    username        => shift || "username", 
    serverHost      => shift || "hostname", 
    serverPort      => shift || 25565
  },$pkg;
}

sub send {
    my $self = shift;
    my $fh = shift;
    $self->sendPacket( $fh, pack("C", 2) );
    $self->sendByte($fh, 60);
    $self->sendString($fh, "aki017");
    $self->sendString($fh, "localhost");
    $sockaddr = getsockname($fh);
    ($port,  $iaddr) = sockaddr_in($sockaddr);
    $self->sendInt($fh, $port);
}

sub recv {
    my $self = shift;
    my $fh = shift;
    $self->{protocolVersion} = $self->recvByte($fh);
    $self->{username}        = $self->recvString($fh, 16);
    $self->{serverHost}      = $self->recvString($fh, 255);
    $self->{serverPort}      = $self->recvInt($fh);
    $self;
}

1;
