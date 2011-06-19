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
	${SED} -i '' -e 's:/etc/mcollective:/usr/local/etc/mcollective:' ${WRKSRC}/lib/mcollective/config.rb
	${SED} -i '' -e 's:/etc/mcollective:/usr/local/etc/mcollective:' ${WRKSRC}/lib/mcollective/rpc.rb
	${SED} -i '' -e 's:/etc/mcollective:/usr/local/etc/mcollective:' ${WRKSRC}/lib/mcollective/util.rb

do-install:
	${MKDIR} ${DATADIR}
	@exec mkdir -p ${PREFIX}/etc/mcollective
	@exec mkdir -p ${PREFIX}/etc/mcollective/ssl
	( cd ${WRKSRC}/lib     && ${COPYTREE_SHARE} \* ${RUBY_SITELIBDIR}/ )
	( cd ${WRKSRC}/plugins/mcollective && ${COPYTREE_SHARE} \* ${DATADIR}/ )

.include <bsd.port.mk>
