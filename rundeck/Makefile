# New ports collection makefile for:   rundeck
# Date created:        28 June 2011
# Whom:                cmccoy
#
# $FreeBSD$
#

PORTNAME=	rundeck
PORTVERSION=	1.2.0
CATEGORIES=	sysutils
MASTER_SITES=	https://github.com/downloads/dtolabs/rundeck/
DISTFILES=	rundeck-launcher-1.2.1.jar

MAINTAINER=   	bsdports@csnstores.com
COMMENT=       cross-platform open source software that helps you automate ad-hoc and routine procedures in data center or cloud environments

NO_WRKSUBDIR=	1
NO_BUILD=	1
USE_JAVA=	1
STRIP=
DATADIR=	${JAVASHAREDIR}/${PORTNAME}

post-extract:
	${CP} ${DISTDIR}/${DISTFILES}	${WRKSRC}
	${CP} ${FILESDIR}/rundeckd.template ${WRKSRC}/rundeckd
	${CP} -r ${FILESDIR}/etc ${WRKSRC}
	${CP} -r ${FILESDIR}/tools ${WRKSRC}

do-patch:
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/rundeckd
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/console-log4j.properties
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/framework.properties
	${SED} -i '' -e 's:JAVA_HOME:${JAVA_HOME}:' ${WRKSRC}/etc/framework.properties
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/log4j.properties
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/preferences.properties
	${SED} -i '' -e 's:JAVA_HOME:${JAVA_HOME}:' ${WRKSRC}/etc/preferences.properties
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/project.properties
	${SED} -i '' -e 's:JAVA_HOME:${DATADIR}:' ${WRKSRC}/etc/project.properties
	${SED} -i '' -e 's:INSTALL_DIR:${DATADIR}:' ${WRKSRC}/etc/profile
	${SED} -i '' -e 's:JAVAHOME:${JAVA_HOME}:' ${WRKSRC}/etc/profile

do-install:
	${MKDIR} ${DATADIR}
	${MKDIR} ${DATADIR}/var
	${MKDIR} ${DATADIR}/projects
	${MKDIR} ${PREFIX}/etc/rc.d
	( cd ${WRKSRC} && ${COPYTREE_SHARE} \* ${DATADIR} )
	${INSTALL_SCRIPT} ${WRKSRC}/rundeckd ${PREFIX}/etc/rc.d/rundeckd
.include <bsd.port.mk>
