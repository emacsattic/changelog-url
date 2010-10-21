;; changelog-url.el --- buttonize PRs in ChangeLog.

;; Copyright (C) 2007 Tom Tromey <tromey@redhat.com>

;; Author: Tom Tromey <tromey@redhat.com>
;; Created: 21 Mar 2007
;; Keywords: tools

;; This file is not (yet) part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Change Log:

;; 21 Mar 2007 - created

;;; Commentary:

;; This turns references to bugs in a ChangeLog buffer into clickable
;; links to the bug system.

;;; ToDo:

;; should buttonize URLs as well.

(defconst changelog-bug-pattern "\\([Bb]ug #\\|PR [a-z-]+/\\)\\([0-9]+\\)"
  "Pattern to match bug system references.")

;; E.g., "http://gcc.gnu.org/PR%s"
(defvar changelog-url-format nil
  "Format used to turn a bug number into a URL.
The bug number is supplied as a string, so this should have a single %s.
There is no default setting for this, it must be set per ChangeLog.")

;;;###autoload
(defun changelog-url-buttonize ()
  (when changelog-url-format
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward changelog-bug-pattern nil t)
	(let* ((start (match-beginning 0))
	       (end (match-end 0))
	       (number (buffer-substring-no-properties (match-beginning 2)
						       (match-end 2)))
	       (url (format changelog-url-format number)))
	  (make-button start end
		       'changelog-url url
		       'help-echo (concat "Visit bug at " url)
		       'action (lambda (button &rest ignore)
				 (let ((url (button-get button
							'changelog-url)))
				   (browse-url url)))))))))
