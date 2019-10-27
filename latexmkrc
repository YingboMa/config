$recorder = 1;
$pdf_mode = 1;
$bibtex_use = 2;
$pdflatex = "pdflatex --shell-escape -interaction=nonstopmode -synctex=1 %O %S";
@default_files = ('main.tex');
$out_dir = 'output';
$aux_dir = 'output';

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  }
  else {
    system "makeglossaries '$_[0]'";
  };
}

push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
