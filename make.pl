#!/usr/bin/env perl 

###
### Search on CHECK
###
### I left off working on index.tmpl.  It still has boilerplate project 
### thumbnails along with my real project thumbs.
###

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

if( 0 ) { show_vars_and_die( $vars ); }
my $templates   = get_template_list();
write_output_files( $tt, $templates, $vars );


sub get_all_vars() {#{{{
    my $vars = get_default_vars();
    $vars = add_sparrow_vars($vars);

    ### Add calls to other more specific var setters.  We might need subs 
    ### specific to one or more templates for whatever reason.
}#}}}
sub get_default_vars() {#{{{
    my $vars =  {
        email               => get_company_emails(),
        social              => get_company_social_accounts(),
        phone               => "(123) 456-7890 ext. abc",
        physical_address    => get_physical_address(),
        portfolio           => get_portfolio(),
        top_title           => "Jon's Site",
    };

    $vars = add_about_page_variables($vars);
    $vars = add_team_variables($vars);
    $vars = add_slide_variables($vars);

    return $vars;
}#}}}
sub add_about_page_variables( $vars ) {#{{{
    my $about = {
        page_head           => 'About Us',
        page_subhead        => 'Aenean condimentum, lacus sit amet luctus lobortis, dolores et quas molestias excepturi enim tellus ultrices elit, amet consequat enim elit noneas sit amet luctu.',
    };
    @$vars{ keys %$about } = values %$about;
    return $vars;
}#}}}
sub add_sparrow_vars( $vars ) {#{{{
    $vars->{'header'} = get_sparrow_header();
    $vars->{'blurbs'} = get_sparrow_index_column_blurbs();
    return $vars;
}#}}}
sub add_team_variables( $vars ) {#{{{
    my $team =  {
        team_header     => "Meet our talented team.",
        team_intro      => get_team_intro(),
        team_members    => get_team_members(),
    };
    @$vars{ keys %$team } = values %$team;
    return $vars;
}#}}}
sub add_slide_variables( $vars ) {#{{{
    $vars->{'slides'} = [
        {
            header      => 'LacunaWaX',
            desc        => "Aenean condimentum, lacus sit amet luctus lobortis, dolores et quas molestias excepturi enim tellus ultrices elit, amet consequat enim elit noneas sit amet luctu. lacus sit amet luctus lobortis, dolores et quas molestias excepturi enim tellus ultrices elit.",
            image       => "images/sliders/slide-wax.png",
            image_alt   => "LacunaWaX Screenshot",
        },
        {
            header      => 'MontyLacuna',
            desc        => "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti eos et accusamus. amet consequat enim elit noneas sit amet luctu.  lacus sit amet luctus lobortis.  Aenean condimentum, lacus sit amet luctus.",
            image       => "images/sliders/slide-wax.png",
            image_alt   => "MontyLacuna Documentation Screenshot",
        },
    ];
    return $vars;
}#}}}
sub get_company_emails {#{{{
    return {
        info            => 'info@example.com',
        sales           => 'sales@example.com',
        tech_support    => 'techguys@example.com',
    }
}#}}}
sub get_company_social_accounts {#{{{
    return {
        facebook    => { type => 'Facebook',   label => 'Example FB page', url => 'http://www.facebook.com/example' },
        twitter     => { type => 'Twitter',    label => '@example', url => 'http://twitter.com/example' },
        google_plus => { type => 'Google +',   label => 'Example G+ page', url => 'http://plus.google.com/example' },
    }
}#}}}
sub get_physical_address {#{{{
    my $a = [
        "Some Studio",
        "123 Main Street",
        "Hereville, HR 12345",
    ];
    return $a;
}#}}}
sub get_portfolio() {#{{{

    ### CHECK
    ### My MontyLacuna and LacunaWaX images were sloppily made, and are not 
    ### exactly the same sizes, neither of which is the correct size.
    ### They're good enough for now, but do need to be re-done.
    my $portfolio =  [
        {
            name        => 'LacunaWaX',
            template    => 'portfolio-entry.tmpl',
            output_file => 'lacunawax.html',
            caption     => 'TLE GUI Client',
            images      => [
                ### The first image gets used as the thumbnail.
                {
                    image       => 'images/portfolio/entries/lw_outer.png',
                    image_alt   => "Intro screen",
                },
                {
                    image       => 'images/portfolio/entries/lw_inner.png',
                    image_alt   => "Welcome (logged-in) screen",
                },
            ],
            subhead             => "Easier UI.",
            full_description    => "Rearrange buildings on a planet's surface, batch rename spies, automatically push glyphs to a common target, manage your sitter passwords, mass push Space Stations propositions, bulk delete your mail. Plus, it comes with full help documentation that I'm convinced nobody has read yet, and it steams vegetables to seal in the vitamins.",
            ### mini_description == sparrow (at least).  Expected to appear 
            ### after "full_description".
            mini_description    => "OK, it won't actually steam your vegetables. But it'll save you some time and help keep some of the blisters off your mouse finger.",
            date                => "May 2013",
            skills              => "Perl, wxwidgets, SQL, JSON-RPC 2.0",
            project_url         => "https://github.com/tmtowtdi/LacunaWaX",
        },
        {
            name    => 'MontyLacuna',
            template    => 'portfolio-entry.tmpl',
            output_file => 'montylacuna.html',
            caption => 'TLE Python Client',
            images  => [
                {
                    image   => 'images/portfolio/entries/monty_docs.png',
                    caption => "Documentation",
                },
            ],
            subhead             => "Easier Setup.",
            full_description    => "Easier setup, fewer prerequisites, creates your config file for you.  Fully documented, easy-to-use API if you want to create your own scripts.  Logging, caching, captcha solving are all taken care of for you.",
            mini_description    => "Plus, it sends excavators to the planet type or types of your choice, without a stars database.",
            date                => "November 2014",
            skills              => "Python, JSON-RPC 2.0",
            project_url         => "http://tmtowtdi.github.io/MontyLacuna/",
        }
    ];
    return $portfolio;
}#}}}
sub get_sparrow_header {#{{{
    ### CHECK
    ### I need to templatize this so I can create a Portfolio entry per 
    ### project.
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
                        <li><a href="montylacuna.html">MontyLacuna</a></li>
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
sub get_sparrow_index_column_blurbs {#{{{
    return [
        {
            header  => "Clean &amp; Modern",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "Responsive",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "HTML5 + CSS3",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "Free of Charge",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
    ];
}#}}}
sub get_team_intro {#{{{
    my $paragraphs = [
        "Proin gravida nibh vel velit auctor aliquet. Aenean sollicitudin, lorem quis bibendum auctor,
        nisi elit consequat ipsum, nec sagittis sem nibh id elit. Duis sed odio sit amet nibh vulputate
        cursus a sit amet mauris. Morbi accumsan ipsum velit.",

        "Proin gravida nibh vel velit auctor aliquet. Aenean sollicitudin, lorem quis bibendum auctor,
        nisi elit consequat ipsum, nec sagittis sem nibh id elit. Duis sed odio sit amet nibh vulputate
        cursus a sit amet mauris. Morbi accumsan ipsum velit. Nam nec tellus a odio tincidunt auctor a
        ornare odio. Sed non  mauris vitae erat consequat auctor eu in elit.",
    ];
    return $paragraphs;
}#}}}
sub get_team_members {#{{{
    my $team_members = [
        {
            full_name           => "Jon Foo Barton",
            comment             => "Vell, tmt's just zis guy, you know?",
            nick                => "tmtowtdi",
            profile_image_large => "images/team/tmt.png",
            links               => {
                                        facebook    => "http://example.com/Nope",
                                        twitter     => "http://example.com/NorThis",
                                        linkedin    => "http://example.com/ThisEither",
                                        google_plus => "https://plus.google.com/+JonathanBarton_tmtowtdi/posts/p/pub",
                                        skype       => "skype:tim.toady?call",
                                    },
        },
        {
            full_name           => "PGMacDesign",
            comment             => "",
            nick                => "Silmarilos",
            profile_image_large => "images/team/sil.png",
            links               => {
                                    facebook    => "http://example.com/MeEither",
                                },
        },
    ];

    return $team_members;
}#}}}
sub get_tt() {#{{{
    return Template->new({
        INCLUDE_PATH    => './tmpl',
        INTERPOLATE     => 1,
        EVAL_PERL       => 1,
    }) || die "$Template::ERROR\n";
}#}}}
sub get_template_list() {#{{{
    return {
        # template   => html file to be written to
        'index.tmpl'            => 'index.html',
        'portfolio-index.tmpl'  => 'portfolio-index.html',
        #'lacunawax.tmpl'        => 'lacunawax.html',
        'about.tmpl'            => 'about.html',
    }
}#}}}
sub show_vars_and_die( $vars ) {#{{{
    say Dumper $vars;
    say "--------------------------------";
    for my $v (keys %$vars) {
        say $v
    }
    exit;
}#}}}
sub write_output_files( $tt, $tmpls, $vars ) {#{{{
    for my $in( keys %{$tmpls} ) {
        my $out = $tmpls->{$in};
        $tt->process( $in, $vars, $out ) || die $tt->error();
    }
    write_portfolio_entry_files( $tt, $vars );
}#}}}
sub write_portfolio_entry_files( $tt, $vars ) {#{{{
    ### CHECK
    ### This is still not handling the next/prev links at the bottom.  Not 
    ### sure they're needed.
    for my $p( @{$vars->{'portfolio'}} ) {
        my $in  = $p->{'template'};
        my $out = $p->{'output_file'};
        @$p{ keys %$vars } = values %$vars;
        $tt->process( $in, $p, $out ) || die $tt->error();
    }
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


