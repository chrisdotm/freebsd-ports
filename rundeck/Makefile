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

MAINTAINER=    freebsd-ports@brownbagcode.com
COMMENT=       cross-platform open source software that helps you automate ad-hoc and routine procedures in data center or cloud environments

NO_WRKSUBDIR=	1
NO_BUILD=	1
USE_JAVA=	1
STRIP=
INSTALLDIR=	${JAVASHAREDIR}/${PORTNAME}

post-extract:
	${CP} -r ${FILESDIR}/etc ${WRKDIR}
	${CP} -r ${FILESDIR}/server ${WRKDIR}

do-patch:
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/etc/console-log4j.properties
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/etc/framework.properties
	${SED} -i '' -e 's:JAVA_HOME:${JAVA_HOME}:' ${WRKSRC}/etc/framework.properties
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/etc/log4j.properties
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/etc/preferences.properties
	${SED} -i '' -e 's:JAVA_HOME:${JAVA_HOME}:' ${WRKSRC}/etc/preferences.properties
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/server/config/jaas-loginmodule.conf
	${SED} -i '' -e 's:INSTALL_DIR:${INSTALLDIR}:' ${WRKSRC}/server/config/rundeck-config.properties
	${SED} -i '' -e 's:ETCDIR:${ETCDIR}:' ${WRKSRC}/server/config/ssl.properties

do-install:
	${MKDIR} ${INSTALLDIR}
	${MKDIR} ${INSTALLDIR}/com
	${MKDIR} ${INSTALLDIR}/docs
	${MKDIR} ${INSTALLDIR}/lib
	${MKDIR} ${INSTALLDIR}/META-INF
	${MKDIR} ${INSTALLDIR}/org
	${MKDIR} ${INSTALLDIR}/pkgs
	${MKDIR} ${INSTALLDIR}/templates
	${MKDIR} ${INSTALLDIR}/server
	${MKDIR} ${ETCDIR}
	${MKDIR} ${ETCDIR}/projects
	${MKDIR} ${ETCDIR}/rc.d
	( cd ${WRKSRC}/com && ${COPYTREE_SHARE} \* ${INSTALLDIR}/com )
	( cd ${WRKSRC}/docs && ${COPYTREE_SHARE} \* ${INSTALLDIR}/docs )
	( cd ${WRKSRC}/lib && ${COPYTREE_SHARE} \* ${INSTALLDIR}/lib )
	( cd ${WRKSRC}/META-INF && ${COPYTREE_SHARE} \* ${INSTALLDIR}/META-INF )
	( cd ${WRKSRC}/org && ${COPYTREE_SHARE} \* ${INSTALLDIR}/org )
	( cd ${WRKSRC}/pkgs && ${COPYTREE_SHARE} \* ${INSTALLDIR}/pkgs )
	( cd ${WRKSRC}/templates && ${COPYTREE_SHARE} \* ${INSTALLDIR}/templates )
	( cd ${WRKSRC}/server/config && ${COPYTREE_SHARE} \* ${ETCDIR} )
	( cd ${WRKSRC}/etc && ${COPYTREE_SHARE} \* ${ETCDIR} )
	${INSTALL_SCRIPT} ${WRKDIR}/server/sbin/rundeckd ${ETCDIR}/rc.d/rundeckd
.include <bsd.port.mk>
