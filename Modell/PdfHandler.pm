package PdfHandler;

use Moo;

has dbh => ( is => "ro", default => sub { } );

sub is_pdf_uploaded {
  my $self   = shift;
  my %params = (@_);
  
  return 1 
    if -e 'Pdf/CV-Trif-Dragos-Dorin.pdf';
  return 0;
}

__PACKAGE__->meta->make_immutable;

1;
