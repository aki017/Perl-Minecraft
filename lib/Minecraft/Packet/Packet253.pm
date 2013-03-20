package Minecraft::Packet::Packet253;
use base qw(Minecraft::Packet);
use MIME::Base64;

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

    my $bin = $self->recvBytes($fh);

    $self->{PublicKey} = Crypt::OpenSSL::RSA->new_public_key(
        "-----BEGIN PUBLIC KEY-----\n".
        join("\n", encode_base64($bin, "") =~ m/.{1,64}/g).
        # join("", split(/(.{64})/, encode_base64($bin, ""))).
        "\n-----END PUBLIC KEY-----"
    );
    $self->{VerifyToken} = $self->recvBytes( $fh);
    $self;
}
sub send {
    my $self = shift;
    my $fh = shift;

    $self->sendPacket( $fh, pack("C", 253));
    $self->sendString( $fh, $self->{ServerID} );
    my $x509 = $self->{PublicKey}->get_public_key_x509_string();
    my $bin="";
    my @lines = split(/\n/, $x509);
    print $x509;
    shift @lines;
    pop @lines;
    $bin = decode_base64(join("\n", @lines));

    $self->sendBytes( $fh, $bin);
    $self->sendBytes( $fh, $self->{VerifyToken} );
}

1;
