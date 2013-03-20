package Minecraft::Packet::Packet253;
use base qw(Minecraft::Packet);

sub new {
  my $pkg = shift;
  bless {
      ServerID => shift || "-", 
      PublicKey => shift , 
      VerifyToken => shift
  },$pkg;
}

sub recv {
    my $self = shift;
    my $fh = shift;

    $self->{ServerID} = $self->recvString( $fh, 20 );
    $self->{PublicKey} = $self->recvString( $fh);
    $self->{VerifyToken} = $self->recvString( $fh);
}
sub send {
    my $self = shift;
    my $fh = shift;

    use YAML;
    print Dump $self;
    print "1\n";
    $self->sendPacket( $fh, pack("C", 253));
    print "2\n";
    print $self->{ServerID}."\n";
    $self->sendBinary( $fh, $self->{ServerID} );
    print "3\n";
    $self->sendBinary( $fh, $self->{PublicKey} );
    print "4\n";
    $self->sendBinary( $fh, $self->{VerifyToken} );
}

1;
