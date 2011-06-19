PORTNAME=	mcollective-server
PORTVERSION=	1.2.0
CATEGORIES=	sysutils

DISTNAME=	mcollective-${PORTVERSION}
HOMEPAGE=	http://www.puppetlabs.com/mcollective/
MASTER_SITES=	http://puppetlabs.com/downloads/mcollective/
EXTRACT_SUFX=	.tgz

MAINTAINER=	freebsd-ports@brownbagcode.com

NO_BUILD=	1
USE_RUBY=	1
STRIP=

CONFIG_PATH=	/etc/mcollective/server.cfg
LIBDIR_PATH=	/usr/libexec/mcollective
DATADIR=	${PREFIX}/share/mcollective
RUN_DEPENDS=	mcollective-common>=1.2.0:${PORTSDIR}/sysutils/mcollective-common

post-extract:
	${CP} ${FILESDIR}/mcollectived.rc ${WRKDIR}

do-patch:
	${SED} -i '' -e 's:${CONFIG_PATH}:${PREFIX}${CONFIG_PATH}:' ${WRKSRC}/mcollectived.rb
	${SED} -i '' -e 's:${LIBDIR_PATH}:${PREFIX}/share:' ${WRKSRC}/etc/server.cfg.dist

do-install:
	${MKDIR} ${EXAMPLESDIR}
	${MKDIR} ${DOCSDIR}
	${INSTALL_PROGRAM} ${WRKSRC}/mcollectived.rb ${PREFIX}/sbin/mcollectived
	${INSTALL_DATA} ${WRKSRC}/etc/server.cfg.dist ${PREFIX}/etc/mcollective/server.cfg.dist
	${INSTALL_SCRIPT} ${WRKDIR}/mcollectived.rc ${PREFIX}/etc/rc.d/mcollectived
	( cd ${WRKSRC}/etc     && ${COPYTREE_SHARE} \* ${EXAMPLESDIR}/ )
	( cd ${WRKSRC}/doc     && ${COPYTREE_SHARE} \* ${DOCSDIR}/ )

.include <bsd.port.mk>
