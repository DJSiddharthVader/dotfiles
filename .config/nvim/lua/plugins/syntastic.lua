return {
    {
        "vim-syntastic/syntastic",
        pymode_python = 'python3',
        syntastic_python_checkers={'flake8'},
        syntastic_python_pylint_args='--disable=missing-docstring --errors-only',
        syntastic_enable_r_lintr_checker = 1,
        syntastic_R_checkers= {'lintr'},
        syntastic_tex_checkers= {'chktex', 'proselint'},
        syntastic_bash_checkers= {'shellcheck'},
        syntastic_always_populate_loc_list = 1,
        syntastic_auto_loc_list = 1,
        syntastic_check_on_open = 1,
        syntastic_check_on_wq = 0,
    }
}
