#!/usr/bin/env perl 

use v5.20;
use utf8;
use strict;
use warnings;
use warnings    qw(FATAL utf8);
use open        qw(:std :utf8);

use experimental 'signatures';

use Data::Dumper;
use Template;


my $tt          = get_tt();
my $vars        = get_all_vars();
my $templates   = get_template_list();
write_output_files( $templates, $vars );


sub write_output_files( $tmpls, $vars ) {#{{{
    for my $in( keys %{$tmpls} ) {
        my $out = $tmpls->{$in};
        $tt->process( $in, $vars, $out ) || die $tt->error();
    }
}#}}}
sub get_all_vars() {#{{{
    my $vars = get_default_vars();
    $vars = add_sparrow_vars($vars);

    ### Add calls to other more specific var setters.  We might need subs 
    ### specific to one or more templates for whatever reason.
}#}}}
sub get_default_vars() {#{{{
    return {
        top_title => "Jon's Site",
    }
}#}}}
sub add_sparrow_vars( $vars ) {#{{{
    $vars->{'header'} = sparrow_header();
    return $vars;
}#}}}
sub get_tt() {#{{{
    return Template->new({
        INCLUDE_PATH    => './tmpl',
        INTERPOLATE     => 1,
    }) || die "$Template::ERROR\n";
}#}}}
sub get_template_list() {#{{{
    return {
        # template   => html file to be written to
        'index.tmpl'            => 'index.html',
        'portfolio-index.tmpl'  => 'portfolio-index.html',
        'lacunawax.tmpl'        => 'lacunawax.html',
        'about.tmpl'            => 'about.html',
    }
}#}}}
sub sparrow_header {#{{{
    return <<EOH;

   <!-- Header
   ================================================== -->
   <header>

      <div class="row">

         <div class="twelve columns">

            <div class="logo">
               <a href="index.html"><img alt="" src="images/logo.png"></a>
            </div>

            <nav id="nav-wrap">

               <a class="mobile-btn" href="#nav-wrap" title="Show navigation">Show navigation</a>
	            <a class="mobile-btn" href="#" title="Hide navigation">Hide navigation</a>

               <ul id="nav" class="nav">

	               <li class="current"><a href="index.html">Home</a></li>
	               <li><span><a href="blog.html">Blog</a></span>
                     <ul>
                        <li><a href="blog.html">Blog Index</a></li>
                        <li><a href="single.html">Post</a></li>
                     </ul>
                  </li>
                  <li><span><a href="portfolio-index.html">Portfolio</a></span>
                     <ul>
                        <li><a href="portfolio-index.html">Portfolio Index</a></li>
                        <li><a href="lacunawax.html">LacunaWaX</a></li>
                     </ul>
                  </li>
	               <li><a href="about.html">About</a></li>
                  <li><a href="contact.html">Contact</a></li>
                  <li><a href="styles.html">Features</a></li>

               </ul> <!-- end #nav -->

            </nav> <!-- end #nav-wrap -->

         </div>

      </div>

   </header> <!-- Header End -->

EOH
}#}}}



__END__

=head1 make.pl

make.pl - Dump out HTML files from templates.

=head1 SYNOPSIS

 $ perl make.pl

=head1 DESCRIPTION

make.pl gathers up a list of template files and common data (page title, 
headers, etc), and produces HTML files from those templates.

=head1 HOW TO UPDATE

=head2 Update what files get created

Modify the hashref returned by get_template_list().  The template files 
specified live in tmpl/.

=head2 Update template replacement variables.

get_all_vars() sets variables that should be common across all template sets, 
and then adds variables specific to whichever template set you're working 
with.  For now, get_all_vars() needs to be edited to set the correct 
template-specific variables.

=head1 GOAL

Ultimately, I'd like all template sets to live in subdirectories of the same 
branch, and all content to live in some sort of database (SQLite most likely).

make.pl will then be assigned a template set, and will draw content from the 
single database and apply it to whichever template set was chosen, so the 
entire site's look can be changed by a single run of make.pl.

=head1 AUTHOR

Jonathan D. Barton (jdbarton@gmail.com)

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

=cut


