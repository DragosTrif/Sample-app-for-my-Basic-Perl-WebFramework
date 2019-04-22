package BaseRenderer;

use Moo;

use Template;
use File::Slurp 'read_file';
use JSON;

has views => ( is => "ro", default => sub { 'Templates' } );

sub dispatch {
  my $self   = shift;
  my $params = shift;

  my $route = $params->{action} // 'render_main';

  $self->$route($params);
}

sub _render_template {
  my $self = shift;
  my $file = shift;
  my $vars = shift;

  my $folder = $self->views();
  my $output;

  my $tt = Template->new(
    {
      INCLUDE_PATH => "$folder",
      EVAL_PERL    => 1,
      PRE_PROCESS  => ['static/layout/index.html'],
      POST_PROCESS => ['static/layout/footer.html']
    }
  ) || die $Template::ERROR, "\n";

  my $tempate_code = read_file("$folder/$file");

  $tt->process( \$tempate_code, $vars, \$output ) // die $Template::ERROR;

  return $output;
}

sub _respond_as_json {

  my $self      = shift;
  my $perl_data = shift;

  my $json = JSON->new();

  return $json->pretty->encode($perl_data);
}

__PACKAGE__->meta->make_immutable;

1;
