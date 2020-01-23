#!/usr/bin/env python
# coding=UTF-8
#
"""Bits and pieces for the SQL Alchemy connection."""
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

from .rview import APP

ENGINE = create_engine(APP.config['SQLALCHEMY_DATABASE_URI'], convert_unicode=True)
DB_SESSION = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=ENGINE))
BASE = declarative_base()
BASE.query = DB_SESSION.query_property()
