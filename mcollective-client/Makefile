PORTNAME=	mcollective-client
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
RUN_DEPENDS=	mcollective-common>=1.2.0:${PORTSDIR}/sysutils/mcollective-common


do-patch:
	${SED} -i '' -e 's:${LIBDIR_PATH}:${PREFIX}/share:' ${WRKSRC}/etc/client.cfg.dist

do-install:
	${MKDIR} ${DOCSDIR}
	${MKDIR} ${PREFIX}/etc/mcollective
	${MKDIR} ${PREFIX}/etc/mcollective/ssl
	${INSTALL_PROGRAM} ${WRKSRC}/mco ${PREFIX}/bin/mco
	${INSTALL_PROGRAM} ${WRKSRC}/mc-call-agent ${PREFIX}/sbin/mc-call-agent
	${INSTALL_PROGRAM} ${WRKSRC}/mc-controller ${PREFIX}/sbin/mc-controller
	${INSTALL_PROGRAM} ${WRKSRC}/mc-facts ${PREFIX}/sbin/mc-facts
	${INSTALL_PROGRAM} ${WRKSRC}/mc-find-hosts ${PREFIX}/sbin/mc-find-hosts
	${INSTALL_PROGRAM} ${WRKSRC}/mc-inventory ${PREFIX}/sbin/mc-inventory
	${INSTALL_PROGRAM} ${WRKSRC}/mc-ping ${PREFIX}/sbin/mc-ping
	${INSTALL_PROGRAM} ${WRKSRC}/mc-rpc ${PREFIX}/sbin/mc-rpc
	${INSTALL_PROGRAM} ${WRKSRC}/mcollectived.rb ${PREFIX}/sbin/mcollectived
	${INSTALL_DATA} ${WRKSRC}/etc/client.cfg.dist ${PREFIX}/etc/mcollective/client.cfg.dist
	${INSTALL_DATA} ${WRKSRC}/etc/rpc-help.erb ${PREFIX}/etc/mcollective/rpc-help.erb
	${INSTALL_DATA} ${WRKSRC}/etc/facts.yaml.dist ${PREFIX}/etc/mcollective/facts.yaml.dist
	${INSTALL_DATA} ${WRKSRC}/COPYING ${DOCSDIR}/COPYING

.include <bsd.port.mk>
