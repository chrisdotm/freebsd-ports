PORTNAME=	mcollective-common
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

CONFIG_PATH=	/etc/mcollective/client.cfg
LIBDIR_PATH=	/usr/libexec/mcollective
DATADIR=	${PREFIX}/share/mcollective

do-patch:
	${SED} -i '' -e 's:${CONFIG_PATH}:${PREFIX}${CONFIG_PATH}:' ${WRKSRC}/mcollectived.rb
	${SED} -i '' -e 's:${LIBDIR_PATH}:${PREFIX}/share:' ${WRKSRC}/etc/client.cfg.dist

do-install:
	${MKDIR} ${EXAMPLESDIR}
	${MKDIR} ${DATADIR}
	${MKDIR} ${DOCSDIR}
	${MKDIR} ${PREFIX}/etc/mcollective
	${MKDIR} ${PREFIX}/etc/mcollective/ssl
	( cd ${WRKSRC}/lib     && ${COPYTREE_SHARE} \* ${RUBY_SITELIBDIR}/ )
	( cd ${WRKSRC}/plugins/mcollective && ${COPYTREE_SHARE} \* ${DATADIR}/ )

.include <bsd.port.mk>
