package ShowPdf;

use Moo;
use lib "Lib";
extends "BaseRenderer";

use lib "Modell";
use PdfHandler;
has +views      => ( is => "ro", default => sub { 'Templates' } );
has PdfHandler  => ( is => "ro", default => sub { PdfHandler->new() } );
has tt_file       => ( is => "ro", required => 1 );

sub render_main {
  my $self   = shift;
  my $params = shift;
  
  $self->_render_template( $self->tt_file(), {
    show_pdf => $self->PdfHandler->is_pdf_uploaded(),
    width    => 700,
    height   => 1000,
    route   =>  '/public?about_me=Dragos',
  } );
}

# sub this_project {
#   my $self   = shift;
#   my $params = shift;

# }

__PACKAGE__->meta->make_immutable;

1;
