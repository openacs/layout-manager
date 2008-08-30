alter table layout_includelets add singleton_p char(1) default 't' not null check (singleton_p in ('t', 'f'));
