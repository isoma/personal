;;; This file was automatically generated by SWIG (http://www.swig.org).
;;; Version 2.0.0
;;;
;;; Do not make changes to this file unless you know what you are doing--modify
;;; the SWIG interface file instead.


;;;SWIG wrapper code starts here

;; (cl:defmacro defanonenum (&body enums)
;;    "Converts anonymous enums to defconstants."
;;   `(cl:progn ,@(cl:loop for value in enums
;;                         for index = 0 then (cl:1+ index)
;;                         when (cl:listp value) do (cl:setf index (cl:second value)
;;                                                           value (cl:first value))
;;                         collect `(cl:defconstant ,value ,index))))

;; (cl:eval-when (:compile-toplevel :load-toplevel)
;;   (cl:unless (cl:fboundp 'swig-lispify)
;;     (cl:defun swig-lispify (name flag cl:&optional (package cl:*package*))
;;       (cl:labels ((helper (lst last rest cl:&aux (c (cl:car lst)))
;;                     (cl:cond
;;                       ((cl:null lst)
;;                        rest)
;;                       ((cl:upper-case-p c)
;;                        (helper (cl:cdr lst) 'upper
;;                                (cl:case last
;;                                  ((lower digit) (cl:list* c #\- rest))
;;                                  (cl:t (cl:cons c rest)))))
;;                       ((cl:lower-case-p c)
;;                        (helper (cl:cdr lst) 'lower (cl:cons (cl:char-upcase c) rest)))
;;                       ((cl:digit-char-p c)
;;                        (helper (cl:cdr lst) 'digit 
;;                                (cl:case last
;;                                  ((upper lower) (cl:list* c #\- rest))
;;                                  (cl:t (cl:cons c rest)))))
;;                       ((cl:char-equal c #\_)
;;                        (helper (cl:cdr lst) '_ (cl:cons #\- rest)))
;;                       (cl:t
;;                        (cl:error "Invalid character: ~A" c)))))
;;         (cl:let ((fix (cl:case flag
;;                         ((constant enumvalue) "+")
;;                         (variable "*")
;;                         (cl:t ""))))
;;           (cl:intern
;;            (cl:concatenate
;;             'cl:string
;;             fix
;;             (cl:nreverse (helper (cl:concatenate 'cl:list name) cl:nil cl:nil))
;;             fix)
;;            package))))))

;;;SWIG wrapper code ends here


(cffi:defcfun ("eb_initialize_appendix" eb_initialize_appendix) :void
  (appendix :pointer))

(cffi:defcfun ("eb_finalize_appendix" eb_finalize_appendix) :void
  (appendix :pointer))

(cffi:defcfun ("eb_bind_appendix" eb_bind_appendix) :int
  (appendix :pointer)
  (path :string))

(cffi:defcfun ("eb_is_appendix_bound" eb_is_appendix_bound) :int
  (appendix :pointer))

(cffi:defcfun ("eb_appendix_path" eb_appendix_path) :int
  (appendix :pointer)
  (path :string))

(cffi:defcfun ("eb_load_all_appendix_subbooks" eb_load_all_appendix_subbooks) :int
  (appendix :pointer))

(cffi:defcfun ("eb_appendix_subbook_list" eb_appendix_subbook_list) :int
  (appendix :pointer)
  (subbook_list :pointer)
  (subbook_count :pointer))

(cffi:defcfun ("eb_appendix_subbook" eb_appendix_subbook) :int
  (appendix :pointer)
  (subbook_code :pointer))

(cffi:defcfun ("eb_appendix_subbook_directory" eb_appendix_subbook_directory) :int
  (appendix :pointer)
  (directory :string))

(cffi:defcfun ("eb_appendix_subbook_directory2" eb_appendix_subbook_directory2) :int
  (appendix :pointer)
  (subbook_code :int)
  (directory :string))

(cffi:defcfun ("eb_set_appendix_subbook" eb_set_appendix_subbook) :int
  (appendix :pointer)
  (subbook_code :int))

(cffi:defcfun ("eb_unset_appendix_subbook" eb_unset_appendix_subbook) :void
  (appendix :pointer))

(cffi:defcfun ("eb_have_narrow_alt" eb_have_narrow_alt) :int
  (appendix :pointer))

(cffi:defcfun ("eb_narrow_alt_start" eb_narrow_alt_start) :int
  (appendix :pointer)
  (start :pointer))

(cffi:defcfun ("eb_narrow_alt_end" eb_narrow_alt_end) :int
  (appendix :pointer)
  (end :pointer))

(cffi:defcfun ("eb_narrow_alt_character_text" eb_narrow_alt_character_text) :int
  (appendix :pointer)
  (character_number :int)
  (text :string))

(cffi:defcfun ("eb_forward_narrow_alt_character" eb_forward_narrow_alt_character) :int
  (appendix :pointer)
  (n :int)
  (character_number :pointer))

(cffi:defcfun ("eb_backward_narrow_alt_character" eb_backward_narrow_alt_character) :int
  (appendix :pointer)
  (n :int)
  (character_number :pointer))

(cffi:defcfun ("eb_have_stop_code" eb_have_stop_code) :int
  (appendix :pointer))

(cffi:defcfun ("eb_stop_code" eb_stop_code) :int
  (appendix :pointer)
  (arg1 :pointer))

(cffi:defcfun ("eb_have_wide_alt" eb_have_wide_alt) :int
  (appendix :pointer))

(cffi:defcfun ("eb_wide_alt_start" eb_wide_alt_start) :int
  (appendix :pointer)
  (start :pointer))

(cffi:defcfun ("eb_wide_alt_end" eb_wide_alt_end) :int
  (appendix :pointer)
  (end :pointer))

(cffi:defcfun ("eb_wide_alt_character_text" eb_wide_alt_character_text) :int
  (appendix :pointer)
  (character_number :int)
  (text :string))

(cffi:defcfun ("eb_forward_wide_alt_character" eb_forward_wide_alt_character) :int
  (appendix :pointer)
  (n :int)
  (character_number :pointer))

(cffi:defcfun ("eb_backward_wide_alt_character" eb_backward_wide_alt_character) :int
  (appendix :pointer)
  (n :int)
  (character_number :pointer))

(cffi:defcfun ("eb_set_binary_mono_graphic" eb_set_binary_mono_graphic) :int
  (book :pointer)
  (position :pointer)
  (width :int)
  (height :int))

(cffi:defcfun ("eb_set_binary_gray_graphic" eb_set_binary_gray_graphic) :int
  (book :pointer)
  (position :pointer)
  (width :int)
  (height :int))

(cffi:defcfun ("eb_set_binary_wave" eb_set_binary_wave) :int
  (book :pointer)
  (start_position :pointer)
  (end_position :pointer))

(cffi:defcfun ("eb_set_binary_color_graphic" eb_set_binary_color_graphic) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_set_binary_mpeg" eb_set_binary_mpeg) :int
  (book :pointer)
  (argv :pointer))

(cffi:defcfun ("eb_read_binary" eb_read_binary) :int
  (book :pointer)
  (binary_max_length :pointer)
  (binary :string)
  (binary_length :pointer))

(cffi:defcfun ("eb_unset_binary" eb_unset_binary) :void
  (book :pointer))

(cffi:defcfun ("eb_compose_movie_file_name" eb_compose_movie_file_name) :int
  (argv :pointer)
  (composed_file_name :string))

(cffi:defcfun ("eb_compose_movie_path_name" eb_compose_movie_path_name) :int
  (book :pointer)
  (argv :pointer)
  (composed_path_name :string))

(cffi:defcfun ("eb_decompose_movie_file_name" eb_decompose_movie_file_name) :int
  (argv :pointer)
  (composed_file_name :string))

(cffi:defcfun ("eb_initialize_booklist" eb_initialize_booklist) :void
  (booklist :pointer))

(cffi:defcfun ("eb_finalize_booklist" eb_finalize_booklist) :void
  (booklist :pointer))

(cffi:defcfun ("eb_bind_booklist" eb_bind_booklist) :int
  (booklist :pointer)
  (path :string))

(cffi:defcfun ("eb_booklist_book_count" eb_booklist_book_count) :int
  (booklist :pointer)
  (book_count :pointer))

(cffi:defcfun ("eb_booklist_book_name" eb_booklist_book_name) :int
  (booklist :pointer)
  (book_index :int)
  (book_name :pointer))

(cffi:defcfun ("eb_booklist_book_title" eb_booklist_book_title) :int
  (booklist :pointer)
  (book_index :int)
  (book_title :pointer))

(cl:defconstant EB_DISC_EB 0)

(cl:defconstant EB_DISC_EPWING 1)

(cl:defconstant EB_DISC_INVALID -1)

(cl:defconstant EB_CHARCODE_ISO8859_1 1)

(cl:defconstant EB_CHARCODE_JISX0208 2)

(cl:defconstant EB_CHARCODE_JISX0208_GB2312 3)

(cl:defconstant EB_CHARCODE_INVALID -1)

(cl:defconstant EB_BOOK_NONE -1)

(cl:defconstant EB_SUBBOOK_INVALID -1)

(cl:defconstant EB_MULTI_INVALID -1)

(cl:defconstant EB_SIZE_PAGE 2048)

(cl:defconstant EB_MAX_WORD_LENGTH 255)

(cl:defconstant EB_MAX_EB_TITLE_LENGTH 30)

(cl:defconstant EB_MAX_EPWING_TITLE_LENGTH 80)

(cl:defconstant EB_MAX_TITLE_LENGTH 80)

(cl:defconstant EB_MAX_PATH_LENGTH 1024)

(cl:defconstant EB_MAX_DIRECTORY_NAME_LENGTH 8)

(cl:defconstant EB_MAX_FILE_NAME_LENGTH 14)

(cl:defconstant EB_MAX_MULTI_LABEL_LENGTH 30)

(cl:defconstant EB_MAX_ALTERNATION_TEXT_LENGTH 31)

(cl:defconstant EB_MAX_MULTI_TITLE_LENGTH 32)

(cl:defconstant EB_MAX_FONTS 4)

(cl:defconstant EB_MAX_SUBBOOKS 50)

(cl:defconstant EB_MAX_MULTI_SEARCHES 10)

(cl:defconstant EB_MAX_MULTI_ENTRIES 5)

(cl:defconstant EB_MAX_KEYWORDS 5)

(cl:defconstant EB_MAX_CROSS_ENTRIES 5)

(cl:defconstant EB_MAX_ALTERNATION_CACHE 16)

(cl:defconstant EB_NUMBER_OF_HOOKS 49)

(cl:defconstant EB_NUMBER_OF_SEARCH_CONTEXTS 5)

(cffi:defcstruct EB_Position_Struct
	(page :int)
	(offset :int))

(cffi:defcstruct EB_Alternation_Cache_Struct
	(character_number :int)
	(text :pointer))

(cffi:defcstruct EB_Appendix_Subbook_Struct
	(initialized :int)
	(code :int)
	(directory_name :pointer)
	(data_directory_name :pointer)
	(file_name :pointer)
	(character_code :int)
	(narrow_start :int)
	(wide_start :int)
	(narrow_end :int)
	(wide_end :int)
	(narrow_page :int)
	(wide_page :int)
	(stop_code0 :int)
	(stop_code1 :int)
	(zio :pointer))

(cffi:defcstruct EB_Appendix_Struct
	(code :int)
	(path :string)
	(path_length :pointer)
	(disc_code :int)
	(subbook_count :int)
	(subbooks :pointer)
	(subbook_current :pointer)
	(narrow_cache :pointer)
	(wide_cache :pointer))

(cffi:defcstruct EB_Font_Struct
	(font_code :int)
	(initialized :int)
	(start :int)
	(end :int)
	(page :int)
	(file_name :pointer)
	(glyphs :string)
	(zio :pointer))

(cffi:defcstruct EB_Search_Struct
	(index_id :int)
	(start_page :int)
	(end_page :int)
	(candidates_page :int)
	(katakana :int)
	(lower :int)
	(mark :int)
	(long_vowel :int)
	(double_consonant :int)
	(contracted_sound :int)
	(voiced_consonant :int)
	(small_vowel :int)
	(p_sound :int)
	(space :int)
	(label :pointer))

(cffi:defcstruct EB_Multi_Search_Struct
	(search EB_Search_Struct)
	(title :pointer)
	(entry_count :int)
	(entries :pointer))

(cffi:defcstruct EB_Subbook_Struct
	(initialized :int)
	(index_page :int)
	(code :int)
	(text_zio :pointer)
	(graphic_zio :pointer)
	(sound_zio :pointer)
	(movie_zio :pointer)
	(title :pointer)
	(directory_name :pointer)
	(data_directory_name :pointer)
	(gaiji_directory_name :pointer)
	(movie_directory_name :pointer)
	(text_file_name :pointer)
	(graphic_file_name :pointer)
	(sound_file_name :pointer)
	(text_hint_zio_code :int)
	(graphic_hint_zio_code :int)
	(sound_hint_zio_code :int)
	(search_title_page :int)
	(word_alphabet EB_Search_Struct)
	(word_asis EB_Search_Struct)
	(word_kana EB_Search_Struct)
	(endword_alphabet EB_Search_Struct)
	(endword_asis EB_Search_Struct)
	(endword_kana EB_Search_Struct)
	(keyword EB_Search_Struct)
	(menu EB_Search_Struct)
	(image_menu EB_Search_Struct)
	(cross EB_Search_Struct)
	(copyright EB_Search_Struct)
	(text EB_Search_Struct)
	(sound EB_Search_Struct)
	(multi_count :int)
	(multis :pointer)
	(narrow_fonts :pointer)
	(wide_fonts :pointer)
	(narrow_current :pointer)
	(wide_current :pointer))

(cl:defconstant EB_SIZE_BINARY_CACHE_BUFFER 128)

(cffi:defcstruct EB_Binary_Context_Struct
	(code :int)
	(zio :pointer)
	(location :pointer)
	(size :pointer)
	(offset :pointer)
	(cache_buffer :pointer)
	(cache_length :pointer)
	(cache_offset :pointer)
	(width :int))

(cffi:defcstruct EB_Text_Context_Struct
	(code :int)
	(location :pointer)
	(out :string)
	(out_rest_length :pointer)
	(unprocessed :string)
	(unprocessed_size :pointer)
	(out_step :pointer)
	(narrow_flag :int)
	(printable_count :int)
	(file_end_flag :int)
	(text_status :int)
	(skip_code :int)
	(auto_stop_code :int)
	(candidate :pointer)
	(is_candidate :int))

(cffi:defcstruct EB_Search_Context_Struct
	(code :int)
	(compare_pre :pointer)
	(compare_single :pointer)
	(compare_group :pointer)
	(comparison_result :int)
	(word :pointer)
	(canonicalized_word :pointer)
	(page :int)
	(offset :int)
	(page_id :int)
	(entry_count :int)
	(entry_index :int)
	(entry_length :int)
	(entry_arrangement :int)
	(in_group_entry :int)
	(keyword_heading EB_Position_Struct))

(cffi:defcstruct EB_Book_Struct
	(code :int)
	(disc_code :int)
	(character_code :int)
	(path :string)
	(path_length :pointer)
	(subbook_count :int)
	(subbooks :pointer)
	(subbook_current :pointer)
	(text_context EB_Text_Context_Struct)
	(binary_context EB_Binary_Context_Struct)
	(search_contexts :pointer))

(cffi:defcstruct EB_Hit_Struct
	(heading EB_Position_Struct)
	(text EB_Position_Struct))

(cffi:defcstruct EB_Hook_Struct
	(code :int)
	(function :pointer))

(cffi:defcstruct EB_Hookset_Struct
	(hooks :pointer))

(cffi:defcstruct EB_BookList_Entry
	(name :string)
	(title :string))

(cffi:defcstruct EB_BookList
	(code :int)
	(entry_count :int)
	(max_entry_count :int)
	(entries :pointer))

(cffi:defcfun ("eb_initialize_book" eb_initialize_book) :void
  (book :pointer))

(cffi:defcfun ("eb_bind" eb_bind) :int
  (book :pointer)
  (path :string))

(cffi:defcfun ("eb_finalize_book" eb_finalize_book) :void
  (book :pointer))

(cffi:defcfun ("eb_is_bound" eb_is_bound) :int
  (book :pointer))

(cffi:defcfun ("eb_path" eb_path) :int
  (book :pointer)
  (path :string))

(cffi:defcfun ("eb_disc_type" eb_disc_type) :int
  (book :pointer)
  (disc_code :pointer))

(cffi:defcfun ("eb_character_code" eb_character_code) :int
  (book :pointer)
  (character_code :pointer))

(cffi:defcfun ("eb_have_copyright" eb_have_copyright) :int
  (book :pointer))

(cffi:defcfun ("eb_copyright" eb_copyright) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_search_cross" eb_search_cross) :int
  (book :pointer)
  (input_words :pointer))

(cffi:defcfun ("eb_have_cross_search" eb_have_cross_search) :int
  (book :pointer))

(cffi:defcfun ("eb_initialize_library" eb_initialize_library) :int)

(cffi:defcfun ("eb_finalize_library" eb_finalize_library) :void)

(cffi:defcfun ("eb_have_endword_search" eb_have_endword_search) :int
  (book :pointer))

(cffi:defcfun ("eb_search_endword" eb_search_endword) :int
  (book :pointer)
  (input_word :string))

(cffi:defcfun ("eb_have_exactword_search" eb_have_exactword_search) :int
  (book :pointer))

(cffi:defcfun ("eb_search_exactword" eb_search_exactword) :int
  (book :pointer)
  (input_word :string))

;; (cffi:defcfun ("eb_have_graphic_search" eb_have_graphic_search) :int
;;   (book :pointer))

(cffi:defcfun ("eb_have_keyword_search" eb_have_keyword_search) :int
  (book :pointer))

(cffi:defcfun ("eb_search_keyword" eb_search_keyword) :int
  (book :pointer)
  (input_words :pointer))

(cffi:defcfun ("eb_pthread_enabled" eb_pthread_enabled) :int)

(cffi:defcfun ("eb_set_log_function" eb_set_log_function) :void
  (function :pointer))

(cffi:defcfun ("eb_enable_log" eb_enable_log) :void)

(cffi:defcfun ("eb_disable_log" eb_disable_log) :void)

(cffi:defcfun ("eb_log" eb_log) :void
  (message :string)
  &rest)

(cffi:defcfun ("eb_log_stderr" eb_log_stderr) :void
  (message :string)
  (ap :pointer))

(cffi:defcfun ("eb_have_menu" eb_have_menu) :int
  (book :pointer))

(cffi:defcfun ("eb_menu" eb_menu) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_have_image_menu" eb_have_image_menu) :int
  (book :pointer))

(cffi:defcfun ("eb_image_menu" eb_image_menu) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_have_multi_search" eb_have_multi_search) :int
  (book :pointer))

(cffi:defcfun ("eb_multi_title" eb_multi_title) :int
  (book :pointer)
  (multi_id :int)
  (title :string))

(cffi:defcfun ("eb_multi_search_list" eb_multi_search_list) :int
  (book :pointer)
  (search_list :pointer)
  (search_count :pointer))

(cffi:defcfun ("eb_multi_entry_count" eb_multi_entry_count) :int
  (book :pointer)
  (multi_id :int)
  (entry_count :pointer))

(cffi:defcfun ("eb_multi_entry_list" eb_multi_entry_list) :int
  (book :pointer)
  (multi_id :int)
  (entry_list :pointer)
  (entry_count :pointer))

(cffi:defcfun ("eb_multi_entry_label" eb_multi_entry_label) :int
  (book :pointer)
  (multi_id :int)
  (entry_index :int)
  (label :string))

(cffi:defcfun ("eb_multi_entry_have_candidates" eb_multi_entry_have_candidates) :int
  (book :pointer)
  (multi_id :int)
  (entry_index :int))

(cffi:defcfun ("eb_multi_entry_candidates" eb_multi_entry_candidates) :int
  (book :pointer)
  (multi_id :int)
  (entry_index :int)
  (position :pointer))

(cffi:defcfun ("eb_search_multi" eb_search_multi) :int
  (book :pointer)
  (multi_id :int)
  (input_words :pointer))

(cffi:defcfun ("eb_have_text" eb_have_text) :int
  (book :pointer))

(cffi:defcfun ("eb_text" eb_text) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_hit_list" eb_hit_list) :int
  (book :pointer)
  (max_hit_count :int)
  (hit_list :pointer)
  (hit_count :pointer))

(cffi:defcfun ("eb_load_all_subbooks" eb_load_all_subbooks) :int
  (book :pointer))

(cffi:defcfun ("eb_subbook_list" eb_subbook_list) :int
  (book :pointer)
  (subbook_list :pointer)
  (subbook_count :pointer))

(cffi:defcfun ("eb_subbook" eb_subbook) :int
  (book :pointer)
  (subbook_code :pointer))

(cffi:defcfun ("eb_subbook_title" eb_subbook_title) :int
  (book :pointer)
  (title :string))

(cffi:defcfun ("eb_subbook_title2" eb_subbook_title2) :int
  (book :pointer)
  (subbook_code :int)
  (title :string))

(cffi:defcfun ("eb_subbook_directory" eb_subbook_directory) :int
  (book :pointer)
  (directory :string))

(cffi:defcfun ("eb_subbook_directory2" eb_subbook_directory2) :int
  (book :pointer)
  (subbook_code :int)
  (directory :string))

(cffi:defcfun ("eb_set_subbook" eb_set_subbook) :int
  (book :pointer)
  (subbook_code :int))

(cffi:defcfun ("eb_unset_subbook" eb_unset_subbook) :void
  (book :pointer))

(cffi:defcfun ("eb_have_word_search" eb_have_word_search) :int
  (book :pointer))

(cffi:defcfun ("eb_search_word" eb_search_word) :int
  (book :pointer)
  (input_word :string))

(cl:defconstant EB_SUCCESS 0)

(cl:defconstant EB_ERR_MEMORY_EXHAUSTED 1)

(cl:defconstant EB_ERR_EMPTY_FILE_NAME 2)

(cl:defconstant EB_ERR_TOO_LONG_FILE_NAME 3)

(cl:defconstant EB_ERR_BAD_FILE_NAME 4)

(cl:defconstant EB_ERR_BAD_DIR_NAME 5)

(cl:defconstant EB_ERR_TOO_LONG_WORD 6)

(cl:defconstant EB_ERR_BAD_WORD 7)

(cl:defconstant EB_ERR_EMPTY_WORD 8)

(cl:defconstant EB_ERR_FAIL_GETCWD 9)

(cl:defconstant EB_ERR_FAIL_OPEN_CAT 10)

(cl:defconstant EB_ERR_FAIL_OPEN_CATAPP 11)

(cl:defconstant EB_ERR_FAIL_OPEN_TEXT 12)

(cl:defconstant EB_ERR_FAIL_OPEN_FONT 13)

(cl:defconstant EB_ERR_FAIL_OPEN_APP 14)

(cl:defconstant EB_ERR_FAIL_OPEN_BINARY 15)

(cl:defconstant EB_ERR_FAIL_READ_CAT 16)

(cl:defconstant EB_ERR_FAIL_READ_CATAPP 17)

(cl:defconstant EB_ERR_FAIL_READ_TEXT 18)

(cl:defconstant EB_ERR_FAIL_READ_FONT 19)

(cl:defconstant EB_ERR_FAIL_READ_APP 20)

(cl:defconstant EB_ERR_FAIL_READ_BINARY 21)

(cl:defconstant EB_ERR_FAIL_SEEK_CAT 22)

(cl:defconstant EB_ERR_FAIL_SEEK_CATAPP 23)

(cl:defconstant EB_ERR_FAIL_SEEK_TEXT 24)

(cl:defconstant EB_ERR_FAIL_SEEK_FONT 25)

(cl:defconstant EB_ERR_FAIL_SEEK_APP 26)

(cl:defconstant EB_ERR_FAIL_SEEK_BINARY 27)

(cl:defconstant EB_ERR_UNEXP_CAT 28)

(cl:defconstant EB_ERR_UNEXP_CATAPP 29)

(cl:defconstant EB_ERR_UNEXP_TEXT 30)

(cl:defconstant EB_ERR_UNEXP_FONT 31)

(cl:defconstant EB_ERR_UNEXP_APP 32)

(cl:defconstant EB_ERR_UNEXP_BINARY 33)

(cl:defconstant EB_ERR_UNBOUND_BOOK 34)

(cl:defconstant EB_ERR_UNBOUND_APP 35)

(cl:defconstant EB_ERR_NO_SUB 36)

(cl:defconstant EB_ERR_NO_APPSUB 37)

(cl:defconstant EB_ERR_NO_FONT 38)

(cl:defconstant EB_ERR_NO_TEXT 39)

(cl:defconstant EB_ERR_NO_STOPCODE 40)

(cl:defconstant EB_ERR_NO_ALT 41)

(cl:defconstant EB_ERR_NO_CUR_SUB 42)

(cl:defconstant EB_ERR_NO_CUR_APPSUB 43)

(cl:defconstant EB_ERR_NO_CUR_FONT 44)

(cl:defconstant EB_ERR_NO_CUR_BINARY 45)

(cl:defconstant EB_ERR_NO_SUCH_SUB 46)

(cl:defconstant EB_ERR_NO_SUCH_APPSUB 47)

(cl:defconstant EB_ERR_NO_SUCH_FONT 48)

(cl:defconstant EB_ERR_NO_SUCH_CHAR_BMP 49)

(cl:defconstant EB_ERR_NO_SUCH_CHAR_TEXT 50)

(cl:defconstant EB_ERR_NO_SUCH_SEARCH 51)

(cl:defconstant EB_ERR_NO_SUCH_HOOK 52)

(cl:defconstant EB_ERR_NO_SUCH_BINARY 53)

(cl:defconstant EB_ERR_DIFF_CONTENT 54)

(cl:defconstant EB_ERR_NO_PREV_SEARCH 55)

(cl:defconstant EB_ERR_NO_SUCH_MULTI_ID 56)

(cl:defconstant EB_ERR_NO_SUCH_ENTRY_ID 57)

(cl:defconstant EB_ERR_TOO_MANY_WORDS 58)

(cl:defconstant EB_ERR_NO_WORD 59)

(cl:defconstant EB_ERR_NO_CANDIDATES 60)

(cl:defconstant EB_ERR_END_OF_CONTENT 61)

(cl:defconstant EB_ERR_NO_PREV_SEEK 62)

(cl:defconstant EB_ERR_EBNET_UNSUPPORTED 63)

(cl:defconstant EB_ERR_EBNET_FAIL_CONNECT 64)

(cl:defconstant EB_ERR_EBNET_SERVER_BUSY 65)

(cl:defconstant EB_ERR_EBNET_NO_PERMISSION 66)

(cl:defconstant EB_ERR_UNBOUND_BOOKLIST 67)

(cl:defconstant EB_ERR_NO_SUCH_BOOK 68)

(cl:defconstant EB_NUMBER_OF_ERRORS 69)

(cl:defconstant EB_MAX_ERROR_MESSAGE_LENGTH 127)

(cffi:defcfun ("eb_error_string" eb_error_string) :string
  (error_code :int))

(cffi:defcfun ("eb_error_message" eb_error_message) :string
  (error_code :int))

(cl:defconstant EB_FONT_16 0)

(cl:defconstant EB_FONT_24 1)

(cl:defconstant EB_FONT_30 2)

(cl:defconstant EB_FONT_48 3)

(cl:defconstant EB_FONT_INVALID -1)

(cl:defconstant EB_SIZE_NARROW_FONT_16 16)

(cl:defconstant EB_SIZE_WIDE_FONT_16 32)

(cl:defconstant EB_SIZE_NARROW_FONT_24 48)

(cl:defconstant EB_SIZE_WIDE_FONT_24 72)

(cl:defconstant EB_SIZE_NARROW_FONT_30 60)

(cl:defconstant EB_SIZE_WIDE_FONT_30 120)

(cl:defconstant EB_SIZE_NARROW_FONT_48 144)

(cl:defconstant EB_SIZE_WIDE_FONT_48 288)

(cl:defconstant EB_WIDTH_NARROW_FONT_16 8)

(cl:defconstant EB_WIDTH_WIDE_FONT_16 16)

(cl:defconstant EB_WIDTH_NARROW_FONT_24 16)

(cl:defconstant EB_WIDTH_WIDE_FONT_24 24)

(cl:defconstant EB_WIDTH_NARROW_FONT_30 16)

(cl:defconstant EB_WIDTH_WIDE_FONT_30 32)

(cl:defconstant EB_WIDTH_NARROW_FONT_48 24)

(cl:defconstant EB_WIDTH_WIDE_FONT_48 48)

(cl:defconstant EB_HEIGHT_FONT_16 16)

(cl:defconstant EB_HEIGHT_FONT_24 24)

(cl:defconstant EB_HEIGHT_FONT_30 30)

(cl:defconstant EB_HEIGHT_FONT_48 48)

(cl:defconstant EB_SIZE_NARROW_FONT_16_XBM 184)

(cl:defconstant EB_SIZE_WIDE_FONT_16_XBM 284)

(cl:defconstant EB_SIZE_NARROW_FONT_16_XPM 266)

(cl:defconstant EB_SIZE_WIDE_FONT_16_XPM 395)

(cl:defconstant EB_SIZE_NARROW_FONT_16_GIF 186)

(cl:defconstant EB_SIZE_WIDE_FONT_16_GIF 314)

(cl:defconstant EB_SIZE_NARROW_FONT_16_BMP 126)

(cl:defconstant EB_SIZE_WIDE_FONT_16_BMP 126)

(cl:defconstant EB_SIZE_NARROW_FONT_16_PNG 131)

(cl:defconstant EB_SIZE_WIDE_FONT_16_PNG 147)

(cl:defconstant EB_SIZE_NARROW_FONT_24_XBM 383)

(cl:defconstant EB_SIZE_WIDE_FONT_24_XBM 533)

(cl:defconstant EB_SIZE_NARROW_FONT_24_XPM 555)

(cl:defconstant EB_SIZE_WIDE_FONT_24_XPM 747)

(cl:defconstant EB_SIZE_NARROW_FONT_24_GIF 450)

(cl:defconstant EB_SIZE_WIDE_FONT_24_GIF 642)

(cl:defconstant EB_SIZE_NARROW_FONT_24_BMP 158)

(cl:defconstant EB_SIZE_WIDE_FONT_24_BMP 158)

(cl:defconstant EB_SIZE_NARROW_FONT_24_PNG 171)

(cl:defconstant EB_SIZE_WIDE_FONT_24_PNG 195)

(cl:defconstant EB_SIZE_NARROW_FONT_30_XBM 458)

(cl:defconstant EB_SIZE_WIDE_FONT_30_XBM 833)

(cl:defconstant EB_SIZE_NARROW_FONT_30_XPM 675)

(cl:defconstant EB_SIZE_WIDE_FONT_30_XPM 1155)

(cl:defconstant EB_SIZE_NARROW_FONT_30_GIF 552)

(cl:defconstant EB_SIZE_WIDE_FONT_30_GIF 1032)

(cl:defconstant EB_SIZE_NARROW_FONT_30_BMP 182)

(cl:defconstant EB_SIZE_WIDE_FONT_30_BMP 182)

(cl:defconstant EB_SIZE_NARROW_FONT_30_PNG 189)

(cl:defconstant EB_SIZE_WIDE_FONT_30_PNG 249)

(cl:defconstant EB_SIZE_NARROW_FONT_48_XBM 983)

(cl:defconstant EB_SIZE_WIDE_FONT_48_XBM 1883)

(cl:defconstant EB_SIZE_NARROW_FONT_48_XPM 1419)

(cl:defconstant EB_SIZE_WIDE_FONT_48_XPM 2571)

(cl:defconstant EB_SIZE_NARROW_FONT_48_GIF 1242)

(cl:defconstant EB_SIZE_WIDE_FONT_48_GIF 2394)

(cl:defconstant EB_SIZE_NARROW_FONT_48_BMP 254)

(cl:defconstant EB_SIZE_WIDE_FONT_48_BMP 446)

(cl:defconstant EB_SIZE_NARROW_FONT_48_PNG 291)

(cl:defconstant EB_SIZE_WIDE_FONT_48_PNG 435)

(cl:defconstant EB_SIZE_FONT_IMAGE 2571)

(cffi:defcfun ("eb_narrow_font_xbm_size" eb_narrow_font_xbm_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_xpm_size" eb_narrow_font_xpm_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_gif_size" eb_narrow_font_gif_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_bmp_size" eb_narrow_font_bmp_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_png_size" eb_narrow_font_png_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_xbm_size" eb_wide_font_xbm_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_xpm_size" eb_wide_font_xpm_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_gif_size" eb_wide_font_gif_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_bmp_size" eb_wide_font_bmp_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_png_size" eb_wide_font_png_size) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_bitmap_to_xbm" eb_bitmap_to_xbm) :int
  (bitmap :string)
  (width :int)
  (height :int)
  (xbm :string)
  (xbm_length :pointer))

(cffi:defcfun ("eb_bitmap_to_xpm" eb_bitmap_to_xpm) :int
  (bitmap :string)
  (width :int)
  (height :int)
  (xpm :string)
  (xpm_length :pointer))

(cffi:defcfun ("eb_bitmap_to_gif" eb_bitmap_to_gif) :int
  (bitmap :string)
  (width :int)
  (height :int)
  (gif :string)
  (gif_length :pointer))

(cffi:defcfun ("eb_bitmap_to_bmp" eb_bitmap_to_bmp) :int
  (bitmap :string)
  (width :int)
  (height :int)
  (bmp :string)
  (bmp_length :pointer))

(cffi:defcfun ("eb_bitmap_to_png" eb_bitmap_to_png) :int
  (bitmap :string)
  (width :int)
  (height :int)
  (png :string)
  (png_length :pointer))

(cffi:defcfun ("eb_font" eb_font) :int
  (book :pointer)
  (font_code :pointer))

(cffi:defcfun ("eb_set_font" eb_set_font) :int
  (book :pointer)
  (font_code :int))

(cffi:defcfun ("eb_unset_font" eb_unset_font) :void
  (book :pointer))

(cffi:defcfun ("eb_font_list" eb_font_list) :int
  (book :pointer)
  (font_list :pointer)
  (font_count :pointer))

(cffi:defcfun ("eb_have_font" eb_have_font) :int
  (book :pointer)
  (font_code :int))

(cffi:defcfun ("eb_font_height" eb_font_height) :int
  (book :pointer)
  (height :pointer))

(cffi:defcfun ("eb_font_height2" eb_font_height2) :int
  (font_code :int)
  (height :pointer))

(cffi:defcfun ("eb_have_narrow_font" eb_have_narrow_font) :int
  (book :pointer))

(cffi:defcfun ("eb_narrow_font_width" eb_narrow_font_width) :int
  (book :pointer)
  (width :pointer))

(cffi:defcfun ("eb_narrow_font_width2" eb_narrow_font_width2) :int
  (font_code :int)
  (width :pointer))

(cffi:defcfun ("eb_narrow_font_size" eb_narrow_font_size) :int
  (book :pointer)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_size2" eb_narrow_font_size2) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_narrow_font_start" eb_narrow_font_start) :int
  (book :pointer)
  (start :pointer))

(cffi:defcfun ("eb_narrow_font_end" eb_narrow_font_end) :int
  (book :pointer)
  (end :pointer))

(cffi:defcfun ("eb_narrow_font_character_bitmap" eb_narrow_font_character_bitmap) :int
  (book :pointer)
  (arg1 :int)
  (arg2 :string))

(cffi:defcfun ("eb_forward_narrow_font_character" eb_forward_narrow_font_character) :int
  (book :pointer)
  (arg1 :int)
  (arg2 :pointer))

(cffi:defcfun ("eb_backward_narrow_font_character" eb_backward_narrow_font_character) :int
  (book :pointer)
  (arg1 :int)
  (arg2 :pointer))

(cffi:defcfun ("eb_have_wide_font" eb_have_wide_font) :int
  (book :pointer))

(cffi:defcfun ("eb_wide_font_width" eb_wide_font_width) :int
  (book :pointer)
  (width :pointer))

(cffi:defcfun ("eb_wide_font_width2" eb_wide_font_width2) :int
  (font_code :int)
  (width :pointer))

(cffi:defcfun ("eb_wide_font_size" eb_wide_font_size) :int
  (book :pointer)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_size2" eb_wide_font_size2) :int
  (font_code :int)
  (size :pointer))

(cffi:defcfun ("eb_wide_font_start" eb_wide_font_start) :int
  (book :pointer)
  (start :pointer))

(cffi:defcfun ("eb_wide_font_end" eb_wide_font_end) :int
  (book :pointer)
  (end :pointer))

(cffi:defcfun ("eb_wide_font_character_bitmap" eb_wide_font_character_bitmap) :int
  (book :pointer)
  (character_number :int)
  (bitmap :string))

(cffi:defcfun ("eb_forward_wide_font_character" eb_forward_wide_font_character) :int
  (book :pointer)
  (n :int)
  (character_number :pointer))

(cffi:defcfun ("eb_backward_wide_font_character" eb_backward_wide_font_character) :int
  (book :pointer)
  (n :int)
  (character_number :pointer))

(cl:defconstant EB_VERSION_STRING "4.4.1")

(cl:defconstant EB_VERSION_MAJOR 4)

(cl:defconstant EB_VERSION_MINOR 4)

(cl:defconstant EB_ENABLE_EBNET 1)

(cl:defconstant EB_HOOK_NULL -1)

(cl:defconstant EB_HOOK_INITIALIZE 0)

(cl:defconstant EB_HOOK_BEGIN_NARROW 1)

(cl:defconstant EB_HOOK_END_NARROW 2)

(cl:defconstant EB_HOOK_BEGIN_SUBSCRIPT 3)

(cl:defconstant EB_HOOK_END_SUBSCRIPT 4)

(cl:defconstant EB_HOOK_SET_INDENT 5)

(cl:defconstant EB_HOOK_NEWLINE 6)

(cl:defconstant EB_HOOK_BEGIN_SUPERSCRIPT 7)

(cl:defconstant EB_HOOK_END_SUPERSCRIPT 8)

(cl:defconstant EB_HOOK_BEGIN_NO_NEWLINE 9)

(cl:defconstant EB_HOOK_END_NO_NEWLINE 10)

(cl:defconstant EB_HOOK_BEGIN_EMPHASIS 11)

(cl:defconstant EB_HOOK_END_EMPHASIS 12)

(cl:defconstant EB_HOOK_BEGIN_CANDIDATE 13)

(cl:defconstant EB_HOOK_END_CANDIDATE_GROUP 14)

(cl:defconstant EB_HOOK_END_CANDIDATE_LEAF 15)

(cl:defconstant EB_HOOK_BEGIN_REFERENCE 16)

(cl:defconstant EB_HOOK_END_REFERENCE 17)

(cl:defconstant EB_HOOK_BEGIN_KEYWORD 18)

(cl:defconstant EB_HOOK_END_KEYWORD 19)

(cl:defconstant EB_HOOK_NARROW_FONT 20)

(cl:defconstant EB_HOOK_WIDE_FONT 21)

(cl:defconstant EB_HOOK_ISO8859_1 22)

(cl:defconstant EB_HOOK_NARROW_JISX0208 23)

(cl:defconstant EB_HOOK_WIDE_JISX0208 24)

(cl:defconstant EB_HOOK_GB2312 25)

(cl:defconstant EB_HOOK_BEGIN_MONO_GRAPHIC 26)

(cl:defconstant EB_HOOK_END_MONO_GRAPHIC 27)

(cl:defconstant EB_HOOK_BEGIN_GRAY_GRAPHIC 28)

(cl:defconstant EB_HOOK_END_GRAY_GRAPHIC 29)

(cl:defconstant EB_HOOK_BEGIN_COLOR_BMP 30)

(cl:defconstant EB_HOOK_BEGIN_COLOR_JPEG 31)

(cl:defconstant EB_HOOK_BEGIN_IN_COLOR_BMP 32)

(cl:defconstant EB_HOOK_BEGIN_IN_COLOR_JPEG 33)

(cl:defconstant EB_HOOK_END_COLOR_GRAPHIC 34)

(cl:defconstant EB_HOOK_END_IN_COLOR_GRAPHIC 35)

(cl:defconstant EB_HOOK_BEGIN_WAVE 36)

(cl:defconstant EB_HOOK_END_WAVE 37)

(cl:defconstant EB_HOOK_BEGIN_MPEG 38)

(cl:defconstant EB_HOOK_END_MPEG 39)

(cl:defconstant EB_HOOK_BEGIN_GRAPHIC_REFERENCE 40)

(cl:defconstant EB_HOOK_END_GRAPHIC_REFERENCE 41)

(cl:defconstant EB_HOOK_GRAPHIC_REFERENCE 42)

(cl:defconstant EB_HOOK_BEGIN_DECORATION 43)

(cl:defconstant EB_HOOK_END_DECORATION 44)

(cl:defconstant EB_HOOK_BEGIN_IMAGE_PAGE 45)

(cl:defconstant EB_HOOK_END_IMAGE_PAGE 46)

(cl:defconstant EB_HOOK_BEGIN_CLICKABLE_AREA 47)

(cl:defconstant EB_HOOK_END_CLICKABLE_AREA 48)

(cffi:defcfun ("eb_initialize_hookset" eb_initialize_hookset) :void
  (hookset :pointer))

(cffi:defcfun ("eb_finalize_hookset" eb_finalize_hookset) :void
  (hookset :pointer))

(cffi:defcfun ("eb_set_hook" eb_set_hook) :int
  (hookset :pointer)
  (hook :pointer))

(cffi:defcfun ("eb_set_hooks" eb_set_hooks) :int
  (hookset :pointer)
  (hook :pointer))

(cffi:defcfun ("eb_hook_euc_to_ascii" eb_hook_euc_to_ascii) :int
  (book :pointer)
  (appendix :pointer)
  (container :pointer)
  (hook_code :int)
  (argc :int)
  (argv :pointer))

;; (cffi:defcfun ("eb_hook_stop_code" eb_hook_stop_code) :int
;;   (book :pointer)
;;   (appendix :pointer)
;;   (container :pointer)
;;   (hook_code :int)
;;   (argc :int)
;;   (argv :pointer))

(cffi:defcfun ("eb_hook_narrow_character_text" eb_hook_narrow_character_text) :int
  (book :pointer)
  (appendix :pointer)
  (container :pointer)
  (hook_code :int)
  (argc :int)
  (argv :pointer))

(cffi:defcfun ("eb_hook_wide_character_text" eb_hook_wide_character_text) :int
  (book :pointer)
  (appendix :pointer)
  (container :pointer)
  (hook_code :int)
  (argc :int)
  (argv :pointer))

(cffi:defcfun ("eb_hook_newline" eb_hook_newline) :int
  (book :pointer)
  (appendix :pointer)
  (container :pointer)
  (hook_code :int)
  (argc :int)
  (argv :pointer))

(cffi:defcfun ("eb_hook_empty" eb_hook_empty) :int
  (book :pointer)
  (appendix :pointer)
  (container :pointer)
  (hook_code :int)
  (argc :int)
  (argv :pointer))

(cffi:defcfun ("eb_seek_text" eb_seek_text) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_tell_text" eb_tell_text) :int
  (book :pointer)
  (position :pointer))

(cffi:defcfun ("eb_read_text" eb_read_text) :int
  (book :pointer)
  (appendix :pointer)
  (hookset :pointer)
  (container :pointer)
  (text_max_length :pointer)
  (text :string)
  (text_length :pointer))

(cffi:defcfun ("eb_read_heading" eb_read_heading) :int
  (book :pointer)
  (appendix :pointer)
  (hookset :pointer)
  (container :pointer)
  (text_max_length :pointer)
  (text :string)
  (text_length :pointer))

(cffi:defcfun ("eb_read_rawtext" eb_read_rawtext) :int
  (book :pointer)
  (text_max_length :pointer)
  (text :string)
  (text_length :pointer))

(cffi:defcfun ("eb_is_text_stopped" eb_is_text_stopped) :int
  (book :pointer))

(cffi:defcfun ("eb_write_text_byte1" eb_write_text_byte1) :int
  (book :pointer)
  (byte1 :int))

(cffi:defcfun ("eb_write_text_byte2" eb_write_text_byte2) :int
  (book :pointer)
  (byte1 :int)
  (byte2 :int))

(cffi:defcfun ("eb_write_text_string" eb_write_text_string) :int
  (book :pointer)
  (string :string))

(cffi:defcfun ("eb_write_text" eb_write_text) :int
  (book :pointer)
  (stream :string)
  (stream_length :pointer))

(cffi:defcfun ("eb_current_candidate" eb_current_candidate) :string
  (book :pointer))

(cffi:defcfun ("eb_forward_text" eb_forward_text) :int
  (book :pointer)
  (appendix :pointer))

(cffi:defcfun ("eb_backward_text" eb_backward_text) :int
  (book :pointer)
  (appendix :pointer))

(cl:defconstant ZIO_SIZE_EBZIP_HEADER 22)

(cl:defconstant ZIO_SIZE_EBZIP_MARGIN 1024)

(cl:defconstant ZIO_MAX_EBZIP_LEVEL 5)

(cl:defconstant ZIO_HUFFMAN_NODE_INTERMEDIATE 0)

(cl:defconstant ZIO_HUFFMAN_NODE_EOF 1)

(cl:defconstant ZIO_HUFFMAN_NODE_LEAF8 2)

(cl:defconstant ZIO_HUFFMAN_NODE_LEAF16 3)

(cl:defconstant ZIO_HUFFMAN_NODE_LEAF32 4)

(cl:defconstant ZIO_PLAIN 0)

(cl:defconstant ZIO_EBZIP1 1)

(cl:defconstant ZIO_EPWING 2)

(cl:defconstant ZIO_EPWING6 3)

(cl:defconstant ZIO_SEBXA 4)

(cl:defconstant ZIO_INVALID -1)

(cl:defconstant ZIO_REOPEN -2)

(cffi:defcstruct Zio_Huffman_Node_Struct
	(type :int)
	(value :unsigned-int)
	(frequency :int)
	(left :pointer)
	(right :pointer))

(cffi:defcstruct Zio_Struct
	(id :int)
	(code :int)
	(file :int)
	(location :pointer)
	(file_size :pointer)
	(slice_size :pointer)
	(zip_level :int)
	(index_width :int)
	(crc :unsigned-int)
	(mtime :pointer)
	(index_location :pointer)
	(index_length :pointer)
	(frequencies_location :pointer)
	(frequencies_length :pointer)
	(huffman_nodes :pointer)
	(huffman_root :pointer)
	(zio_start_location :pointer)
	(zio_end_location :pointer)
	(index_base :pointer)
	(is_ebnet :int))

(cffi:defcfun ("zio_initialize_library" zio_initialize_library) :int)

(cffi:defcfun ("zio_finalize_library" zio_finalize_library) :void)

(cffi:defcfun ("zio_initialize" zio_initialize) :void
  (zio :pointer))

(cffi:defcfun ("zio_finalize" zio_finalize) :void
  (zio :pointer))

(cffi:defcfun ("zio_set_sebxa_mode" zio_set_sebxa_mode) :int
  (zio :pointer)
  (index_location :pointer)
  (index_base :pointer)
  (zio_start_location :pointer)
  (zio_end_location :pointer))

(cffi:defcfun ("zio_open" zio_open) :int
  (zio :pointer)
  (file_name :string)
  (zio_code :int))

(cffi:defcfun ("zio_close" zio_close) :void
  (zio :pointer))

(cffi:defcfun ("zio_file" zio_file) :int
  (zio :pointer))

(cffi:defcfun ("zio_mode" zio_mode) :int
  (zio :pointer))

(cffi:defcfun ("zio_lseek" zio_lseek) :pointer
  (zio :pointer)
  (offset :pointer)
  (whence :int))

(cffi:defcfun ("zio_read" zio_read) :pointer
  (zio :pointer)
  (buffer :string)
  (length :pointer))


