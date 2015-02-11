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

### Must exist as a subdirectory of ./tmpl/
my $skin = 'sparrow';

my $tt          = get_tt();
my $vars        = get_all_vars();
if( 0 ) { show_vars_and_die( $vars ); }

my $templates   = get_template_list();
write_output_files( $tt, $templates, $vars );


sub get_all_vars() {#{{{
    my $vars = get_default_vars();

    if( $skin eq 'sparrow' ) {
        $vars = add_sparrow_vars($vars);
    }

    ### Add calls to other more specific var setters.  We might need subs 
    ### specific to one or more templates for whatever reason.
}#}}}
sub get_default_vars() {#{{{
    my $vars =  {
        blog_posts          => get_recent_blog_posts(),
        ctoa                => get_call_to_action_variables(),
        email               => get_company_emails(),
        social              => get_company_social_accounts(),
        phone               => "(123) 456-7890 ext. abc",
        physical_address    => get_physical_address(),
        portfolio           => get_portfolio(),
        top_title           => "Jon's Site",
    };

    $vars = add_about_page_variables($vars);
    $vars = add_slide_variables($vars);
    $vars = add_team_variables($vars);

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
sub add_team_variables( $vars ) {#{{{
    my $team =  {
        team_header     => "Meet our talented team.",
        team_intro      => get_team_intro(),
        team_members    => get_team_members(),
    };
    @$vars{ keys %$team } = values %$team;
    return $vars;
}#}}}
sub get_call_to_action_variables( ) {#{{{

    ### This whole section is optional.  To skip this section, just return an 
    ### empty hashref.
    ###
    ### This stands out from the rest of the page.  "Call your congressman!" 
    ### "Big sale on Friday", etc.
    ### 
    ### This section is somewhat free-form.  The only key you have to have in 
    ### the hashref if you want this section to display is "text".  If you 
    ### want markup in your that section, you're going to have to add it here.
    ###
    ### "header" and "link" often make sense, and get used by the template if 
    ### they're in the hashref, but they're not required.
    ###
    ### CHECK
    ### Because of the free-formy-ness of the text section, this might need to 
    ### get overwritten on a per-template basis, if a certain template 
    ### requires its own unique <span> or whatever.

    my $ctoa =  {
        header  => "Host This Template Somewhere.",
        text    => "Looking for an awesome and reliable webhosting? Try DreamHost. Get 50 off when you sign up with the promocode STYLESHOUT.  50 what, you ask?  Dollars?  Percent?  Cents?  I dunno, it's not stated.",
        link    => "http://www.example.com",
    };
    @$vars{ keys %$ctoa } = values %$ctoa;
    return $vars;
}#}}}
sub add_slide_variables( $vars ) {#{{{
    $vars->{'slides'} = [
        {
            ### Required
            header      => 'LacunaWaX',
            desc        => "An installable GUI toolkit for The Lacuna Expanse.  No scripting knowledge requried.",
            image       => "images/sliders/slide-wax.png",

            ### Optional, but include it.
            image_alt   => "LacunaWaX Screenshot",

            ### Optional
            link        => "lacunawax.html",
        },
        {
            header      => 'MontyLacuna',
            desc        => "A GLC port to Python.  Easier and quicker to install, not to mention buggier!",
            image       => "images/sliders/slide-monty.png",
            image_alt   => "MontyLacuna Documentation Screenshot",
            link        => "montylacuna.html",
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
            local_path  => 'lacunawax.html',
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
            local_path  => 'montylacuna.html',
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
        },

    ];
    return $portfolio;
}#}}}
sub get_recent_blog_posts {#{{{

    ### This should only return the top 3 or 5 (or whatever) recent blog 
    ### posts, and only their summaries.  It's for posting on "see what we've 
    ### been up to" sections, not for posting on the actual blog section.
    my $a = [
        {
            author  => 'Jonathan D. Barton',
            date    => 'Jan 31, 2014',
            link    => 'single.html',
            summary => 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium.',
            title   => 'Proin gravida nibh vel velit auctor aliquet Aenean sollicitudin auctor.',
        },
        {
            author  => 'Joe R. Blow',
            date    => 'Feb 1, 2014',
            link    => 'single.html',
            summary => 'Iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium.',
            title   => 'Flurble blargle!',
        },
        {
            author  => 'Steve Wozniak',
            date    => 'Dec 1, 2005',
            link    => 'single.html',
            summary => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in laborum.",
            title   => "What's the deal with the turtlenecks?",
        },
    ];

    return $a;
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
        INCLUDE_PATH    => "./tmpl/$skin",
        INTERPOLATE     => 1,
        EVAL_PERL       => 1,
    }) || die "$Template::ERROR\n";
}#}}}
sub get_template_list() {#{{{
    my $templates = {
        # template   => html file to be written to

        sparrow => {
            'index.tmpl'            => 'index.html',
            'portfolio-index.tmpl'  => 'portfolio-index.html',
            'contact.tmpl'          => 'contact.html',
            'about.tmpl'            => 'about.html',
        }
    };
    return $templates->{$skin};
}#}}}
sub show_vars_and_die( $vars ) {#{{{
    my $d = Data::Dumper->new([ $vars ]);
    say $d->Dump;
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
        my $out = $p->{'local_path'};
        @$p{ keys %$vars } = values %$vars;
        $tt->process( $in, $p, $out ) || die $tt->error();
    }
}#}}}

sub add_sparrow_vars( $vars ) {#{{{
    $vars->{'dochead'}      = get_sparrow_dochead();    # Common contents of <head> ... </head>
    $vars->{'header'}       = get_sparrow_header();     # visible page header
    $vars->{'footer'}       = get_sparrow_footer();
    $vars->{'bottom_js'}    = get_sparrow_bottom_js();
    $vars->{'blurbs'}       = get_sparrow_index_column_blurbs();
    return $vars;
}#}}}
sub get_sparrow_bottom_js {#{{{
    ### Javascript that needs to appear at the bottom of every page, just 
    ### above the </body> tag.
    return <<EOJ;
    <!-- Java Script
    ================================================== -->
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="js/jquery-1.10.2.min.js"><\/script>')</script>
    <script type="text/javascript" src="js/jquery-migrate-1.2.1.min.js"></script>

    <script src="js/jquery.flexslider.js"></script>
    <script src="js/doubletaptogo.js"></script>
    <script src="js/init.js"></script> 
EOJ
}#}}}
sub get_sparrow_dochead {#{{{

    ### This is only for <head> contents common to all pages on the site.  You 
    ### can still add additional head content as needed on a 
    ### template-by-template basis.  eg the <title> will be different on each 
    ### page, so it's not seen below.

    return <<EOD;

    <!--- Basic Page Needs
    ================================================== -->
    <meta charset="utf-8">
	<meta name="description" content="">
	<meta name="author" content="">

    <!-- Mobile Specific Metas
    ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<!-- CSS
    ================================================== -->
    <link rel="stylesheet" href="css/default.css">
	<link rel="stylesheet" href="css/layout.css">
    <link rel="stylesheet" href="css/media-queries.css">

    <!-- Script
    ================================================== -->
	<script src="js/modernizr.js"></script>

    <!-- Favicons
	================================================== -->
	<link rel="shortcut icon" href="favicon.ico" > 

EOD
}#}}}
sub get_sparrow_header {#{{{
    ### CHECK
    ### I need to templatize this so I can create a Portfolio entry per 
    ### project.
    ###
    ### "logo.png" is the "sparrow" logo, and would need to be changed.
    return <<EOH;

    <!-- Header
    ================================================== -->
    <header>
        <div class="row">
            <div class="twelve columns">
                <!--
                <div class="logo">
                    <a href="index.html"><img alt="" src="images/logo.png"></a>
                </div>
                -->

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
                    </ul> <!-- end #nav -->
                </nav> <!-- end #nav-wrap -->
            </div>
        </div>
    </header> <!-- Header End -->

EOH
}#}}}
sub get_sparrow_footer {#{{{
    ### CHECK
    ### I need to templatize this so I can create a Portfolio entry per 
    ### project, and otherwise mangle the navigation.
    return <<EOF;

   <!-- footer
   ================================================== -->
   <footer>
      <div class="row">
         <div class="twelve columns">
            <ul class="footer-nav">
                <li><a href="#">Home.</a></li>
              	<li><a href="#">Blog.</a></li>
              	<li><a href="#">Portfolio.</a></li>
              	<li><a href="#">About.</a></li>
              	<li><a href="#">Contact.</a></li>
               <li><a href="#">Features.</a></li>
            </ul>
            <ul class="footer-social">
               <li><a href="#"><i class="fa fa-facebook"></i></a></li>
               <li><a href="#"><i class="fa fa-twitter"></i></a></li>
               <li><a href="#"><i class="fa fa-google-plus"></i></a></li>
               <li><a href="#"><i class="fa fa-linkedin"></i></a></li>
               <li><a href="#"><i class="fa fa-skype"></i></a></li>
               <li><a href="#"><i class="fa fa-rss"></i></a></li>
            </ul>
            <ul class="copyright">
               <li>Copyright &copy; 2014 Sparrow</li> 
               <li>Design by <a href="http://www.styleshout.com/">Styleshout</a></li> 
            </ul>
         </div>
         <div id="go-top" style="display: block;"><a title="Back to Top" href="#">Go To Top</a></div>
      </div>
   </footer> <!-- Footer End-->

EOF
}#}}}
sub get_sparrow_index_column_blurbs {#{{{
    return [
        {
            header  => "Column 1",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "Column 2",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "Column 3",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
        {
            header  => "Column 4",
            text    => "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        },
    ];
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


