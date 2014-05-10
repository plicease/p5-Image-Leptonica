package inc::LeptonicaMakeMaker;
use Moose;

extends qw( Dist::Zilla::Plugin::MakeMaker::Awesome );


override _build_WriteMakefile_args => sub { +{
    %{ super() },
} };

override _build_WriteMakefile_dump => sub {
	my $str = super();
	$str .= <<'END';
use Inline::MakeMaker;
use ExtUtils::Depends;
use File::Spec::Functions;
$WriteMakefileArgs{CONFIGURE} = sub {
	require Alien::Leptonica;
	my $l = Alien::Leptonica->new;
	my $pkg = ExtUtils::Depends->new('Image::Leptonica',);
	$pkg->set_inc( $l->cflags );
	$pkg->set_libs( $l->libs );
	$pkg->add_typemaps( 'typemap' );
	use DDP; p $pkg;
	my @dir = qw( lib Image Leptonica Install );
	mkdir catfile @dir;
	$pkg->save_config( catfile( @dir, 'Files.pm' ) ) );
	use DDP; p $pkg->get_makefile_vars();
	+{ CCFLAGS => $l->cflags,
	   LIBS => $l->libs,
	   $pkg->get_makefile_vars()  };
};
END
	$str;
};

__PACKAGE__->meta->make_immutable;
