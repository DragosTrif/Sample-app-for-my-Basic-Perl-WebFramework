package PdfUploader;

use Moo;
use Data::Dumper;

use lib "Lib";
extends "BaseRenderer";

use lib "Modell";
use PdfHandler;

has +views        => ( is => "ro", default => sub { 'Templates' } );
has tt_file       => ( is => "ro", required => 1 );
has PdfHandler    => ( is => "ro", default => sub { PdfHandler->new() } );

# this should be private
sub upload_pdf {
  my $self   = shift;
  my $params = shift;

  $self->_render_template(
    $self->tt_file(),
    {
      show_pdf => $self->PdfHandler->is_pdf_uploaded(),
    }
  );
}

__PACKAGE__->meta->make_immutable;

1;
