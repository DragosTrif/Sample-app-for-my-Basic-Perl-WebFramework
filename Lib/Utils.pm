package Utils;
use Data::Dumper;
use Exporter::NoWork;
use HTML::Entities 'encode_entities';

use constant MAX_FILE_SIZE => '5242880';

sub load_params {

  my $request = shift;

  my %params;

  foreach my $param ( sort $request->param() ) {
    $params{ encode_entities($param) } =
      encode_entities( $request->param($param) );
  }

  return \%params;

}

sub load_routes {
  my $config = shift;

  my $apps = {};

  foreach my $controller (keys %{$config}) {
    $apps->{$controller} = sub {
      
    my $env     = shift;
    #my $view    = shift;

    my $request = Plack::Request->new($env);
    my $session = Plack::Session->new($env);
    
    my $upload  = $request->upload('pdf');
    upload_file(upload => $upload);
    warn $config->{$controller};
    my $params     = load_params($request);
    my $c = $controller->new({ tt_file => $config->{$controller} });
    my $content    = $c->dispatch($params);
    
    return response(
      request      => $request,
      content      => $content,
      content_type => 'text/html',
    );
    };
  }

  return $apps;
}

sub response {

  my %params = @_;

  my $request = $params{request};
  my $content = $params{content};
  my $type    = $params{content_type};

  my $response = $request->new_response(200);

  $response->content_type($type);
  $response->content($content);
  return $response->finalize;

}

sub upload_file {
  my %params = @_;
  # warn Dumper(%params);
  return 
    unless $params{upload};
  # add more validation
  foreach my $up ($params{upload}) {
    return 
      unless $up->{size} < MAX_FILE_SIZE;
    system('cp', "$up->{tempname}", "./Pdf/CV-Trif-Dragos-Dorin.pdf");
  }
}

sub load_plugins {
 # add session
  my $plugins = {
    AUTHORIZATION => sub {
      "Auth::Basic", authenticator => sub {
        my ( $username, $password ) = @_;

        return $username eq 'Dragos' && $password eq 'Trif';
      };
    },
  };

  return $plugins;

}

1;
